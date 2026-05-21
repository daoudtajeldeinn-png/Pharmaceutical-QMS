
import { supabase } from '@/lib/supabase';
import { db } from '@/db/db';
import { toast } from 'sonner';

export const CLOUD_TABLES = [
    'products',
    'testMethods',
    'testResults',
    'capas',
    'deviations',
    'equipment',
    'chemicalReagents',
    'referenceStandards',
    'qualitySystems',
    'trainingRecords',
    'audits',
    'suppliers',
    'changeControls',
    'marketComplaints',
    'productRecalls',
    'stabilityProtocols',
    'ipqcChecks',
    'coaRecords',
    'masterFormulas',
    'batchRecords',
    'rawMaterials',
    'materialMovements',
    'reconciliationRecords',
    'activities',
    'pharmacopeiaMonographs'
];

export async function syncAllTables() {
    console.log('Starting Cloud Synchronization...');
    let successCount = 0;
    let failCount = 0;
    const errors: string[] = [];

    // ── Step 0: Pull the latest tombstone list from cloud so all workstations
    //            honour admin deletions made on other machines. ──────────────
    try {
        const { syncTombstonesFromCloud } = await import('./DeletedRecordsService');
        await syncTombstonesFromCloud();
        console.log('Tombstones synchronised from cloud.');
    } catch (err) {
        console.warn('Could not sync tombstones – proceeding without:', err);
    }

    for (const tableName of CLOUD_TABLES) {
        try {
            console.log(`Syncing table: ${tableName}`);
            
            // 1. PUSH: Get local data from Dexie
            // Before pushing, remove any locally tombstoned records so they do
            // not get re-uploaded and then immediately ignored on pull.
            const { getDeletedIds } = await import('./DeletedRecordsService');
            const deletedIds = getDeletedIds(tableName);

            // Clean up locally deleted records from Dexie so deletion propagates locally
            if (deletedIds.size > 0) {
                for (const idToDelete of Array.from(deletedIds)) {
                    await (db as any)[tableName].delete(idToDelete);
                }
            }

            const allLocalData = await (db as any)[tableName].toArray();
            const localData = deletedIds.size > 0
                ? allLocalData.filter((item: any) => !deletedIds.has(item.id))
                : allLocalData;
            
            if (localData.length > 0) {
                // Convert Date objects to ISO strings for Supabase
                const dataToPush = localData.map((item: any) => {
                    const cleanItem = { ...item };
                    for (const key in cleanItem) {
                        const dateKeys = ['date', 'time', 'timestamp', 'at', 'expiry', 'next', 'schedule', 'created', 'updated', 'lastLogin'];
                        const isDateKey = dateKeys.some(dk => key.toLowerCase().includes(dk));
                        if (isDateKey && cleanItem[key] instanceof Date) {
                            cleanItem[key] = cleanItem[key].toISOString();
                        }
                    }
                    return cleanItem;
                });

                const { error: pushError } = await supabase
                    .from(tableName)
                    .upsert(dataToPush, { onConflict: 'id' });

                if (pushError) {
                    console.warn(`Push error for ${tableName}:`, pushError);
                    throw pushError;
                }
            }

            // 2. PULL: Get remote data from Supabase
            const { data: remoteData, error: pullError } = await supabase
                .from(tableName)
                .select('*');

            if (pullError) {
                throw pullError;
            }

            if (remoteData) {
                // ── TOMBSTONE FILTER ──────────────────────────────────────────
                // Remove any records that an admin has permanently deleted.
                // This prevents sync from "resurrecting" deleted data.
                const safeData = deletedIds.size > 0
                    ? remoteData.filter((row: any) => {
                        // Supabase tombstones store `record_id`, but different tables may expose it as `id` or `record_id`.
                        const rowId = row.id ?? row.record_id;
                        return rowId ? !deletedIds.has(String(rowId)) : true;
                      })
                    : remoteData;

                // ─────────────────────────────────────────────────────────────

                // Ensure local data exactly matches remote data after push
                const remoteIds = new Set(safeData.map((row: any) => row.id));
                const allLocalDataNow = await (db as any)[tableName].toArray();

                for (const localItem of allLocalDataNow) {
                    if (!remoteIds.has(localItem.id)) {
                        await (db as any)[tableName].delete(localItem.id);
                    }
                }

                // Store remote data as-is (ISO strings stay as strings).
                // Converting to Date objects here caused React error #31 when components
                // rendered date values directly as JSX children. Components that need
                // actual Date methods should call new Date(value) themselves.
                if (safeData.length > 0) {
                    await (db as any)[tableName].bulkPut(safeData);
                }
            }

            successCount++;
        } catch (err: any) {
            console.error(`Failed to sync ${tableName}:`, err);
            failCount++;
            errors.push(`${tableName}: ${err.message || 'Unknown error'}`);
        }
    }

    return { successCount, failCount, errors };
}

export async function verifyCloudConnection() {
    try {
        const { error } = await supabase.from('notifications').select('id').limit(1);
        return !error;
    } catch {
        return false;
    }
}
