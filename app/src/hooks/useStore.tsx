
import React, { createContext, useContext, useReducer, type ReactNode, useEffect } from 'react';
import { db } from '../db/db';
import { type MasterFormula } from '@/data/mfrData';
import {
  type AppState,
  type Action,
  initialState,
  appReducerWithPersistence,
  STORAGE_KEYS,
  migrateFromLocalStorage
} from './storeReducer';

// ==================== Context ====================
const StoreContext = createContext<{
  state: AppState;
  dispatch: React.Dispatch<Action>;
} | null>(null);

// ==================== Provider ====================
export function StoreProvider({ children }: { children: ReactNode }) {
  const [state, dispatch] = useReducer(appReducerWithPersistence, initialState);

  useEffect(() => {
    let isMounted = true;

    // Safety timeout: ensure loading state is cleared within 5 seconds even if DB hangs
    const safetyTimeout = setTimeout(() => {
      if (isMounted && state.isLoading) {
        console.warn("Database initialization timed out. Forcing load state...");
        dispatch({ type: 'SET_ERROR', payload: "Database timeout. Using default state." });
      }
    }, 5000);

    const initData = async () => {
      console.log("Starting DB initialization...");
      try {
        // 1. Initial connection check
        await db.open();
        console.log("Database opened successfully.");

        // 2. Migration Check
        const pCount = await db.products.count();
        if (pCount === 0) {
          const lsProducts = localStorage.getItem(STORAGE_KEYS.PRODUCTS);
          if (lsProducts) {
            console.log("Migrating from LocalStorage to IndexedDB...");
            await migrateFromLocalStorage();
          }
        }

        // 3. Load All Data
        console.log("Fetching collection data...");
        const [
          products, testMethods, testResults, capas, deviations, equipment,
          chemicalReagents, referenceStandards, qualitySystems, trainingRecords,
          audits, suppliers, changeControls, pharmacopeiaMonographs,
          marketComplaints, productRecalls, stabilityProtocols,
          ipqcChecks, coaRecords,
          masterFormulasArr, batchRecords, activities
        ] = await Promise.all([
          db.products.toArray(),
          db.testMethods.toArray(),
          db.testResults.toArray(),
          db.capas.toArray(),
          db.deviations.toArray(),
          db.equipment.toArray(),
          db.chemicalReagents.toArray(),
          db.referenceStandards.toArray(),
          db.qualitySystems.toArray(),
          db.trainingRecords.toArray(),
          db.audits.toArray(),
          db.suppliers.toArray(),
          db.changeControls.toArray(),
          db.pharmacopeiaMonographs.toArray(),
          db.marketComplaints.toArray(),
          db.productRecalls.toArray(),
          db.stabilityProtocols.toArray(),
          db.ipqcChecks.toArray(),
          db.coaRecords.toArray(),
          db.masterFormulas.toArray(),
          db.batchRecords.toArray(),
          db.activities.orderBy('timestamp').reverse().limit(50).toArray(),
        ]);

        console.log("Data fetched, preparing state...");

        // Convert masterFormulas array to record
        const masterFormulas = (masterFormulasArr || []).reduce((acc, curr) => {
          if (curr && curr.id) acc[curr.id] = curr;
          return acc;
        }, {} as Record<string, MasterFormula>);

        if (!isMounted) return;

        dispatch({
          type: 'LOAD_DB_DATA',
          payload: {
            products: products || [],
            testMethods: testMethods || [],
            testResults: testResults || [],
            capas: capas || [],
            deviations: deviations || [],
            equipment: equipment || [],
            chemicalReagents: chemicalReagents || [],
            referenceStandards: referenceStandards || [],
            qualitySystems: qualitySystems || [],
            trainingRecords: trainingRecords || [],
            audits: audits || [],
            suppliers: suppliers || [],
            changeControls: changeControls || [],
            pharmacopeiaMonographs: pharmacopeiaMonographs || [],
            marketComplaints: marketComplaints || [],
            productRecalls: productRecalls || [],
            stabilityProtocols: stabilityProtocols || [],
            ipqcChecks: ipqcChecks || [],
            coaRecords: coaRecords || [],
            masterFormulas: masterFormulas,
            batchRecords: batchRecords || [],
            activities: activities || []
          }
        });

        // Update derived stats
        dispatch({ type: 'UPDATE_DASHBOARD_STATS' });
        console.log("DB initialization complete.");
        clearTimeout(safetyTimeout);

      } catch (err) {
        console.error("Failed to load DB data", err);
        if (isMounted) {
          dispatch({ type: 'SET_ERROR', payload: "Failed to load database. Operating in memory mode." });
          clearTimeout(safetyTimeout);
        }
      }
    };

    initData();
    return () => {
      isMounted = false;
      clearTimeout(safetyTimeout);
    };
  }, []);

  return (
    <StoreContext.Provider value={{ state, dispatch }}>
      {children}
    </StoreContext.Provider>
  );
}

// ==================== Hook ====================
export function useStore() {
  const context = useContext(StoreContext);
  if (!context) {
    throw new Error('useStore must be used within a StoreProvider');
  }
  return context;
}
