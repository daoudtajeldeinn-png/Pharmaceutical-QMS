# دليل التنفيذ السريع | Quick Setup Guide

## ⚡ خطوات التنفيذ في 5 دقائق

### 1. احتياطي (مهم جداً)
```bash
cd Pharmaceutical-QMS
git checkout -b backup-before-cleanup
git add .
git commit -m "backup: before major cleanup"
git checkout main
```

### 2. نسخ الملفات الجديدة
```bash
# انسخ جميع الملفات من هذا المجلد إلى مستودعك
cp -r * /path/to/your/Pharmaceutical-QMS/
```

### 3. تنفيذ التنظيف
```bash
cd /path/to/your/Pharmaceutical-QMS

# إنشاء فرع جديد
git checkout -b major-cleanup-2024

# إضافة الملفات الجديدة
git add .gitignore README.md LICENSE CONTRIBUTING.md SECURITY.md CODE_OF_CONDUCT.md
git add requirements.txt package.json docker-compose.yml Makefile
git add .github/ docs/ src/ tests/ data/ assets/
git commit -m "chore: initialize professional project structure"

# حذف الملفات المؤقتة (إن وجدت)
git rm -r --cached node_modules/ 2>/dev/null || true
git rm -r --cached __pycache__/ 2>/dev/null || true
git rm --cached "*.log" 2>/dev/null || true
git rm --cached .DS_Store 2>/dev/null || true
git commit -m "chore: remove temporary files" || echo "No temp files found"

# دمج مع main
git checkout main
git merge major-cleanup-2024 --no-ff -m "feat: major repository cleanup and reorganization"

# تنظيف
git branch -d major-cleanup-2024
git gc --aggressive --prune=now

# رفع التغييرات
git push origin main
```

### 4. التحقق
- [ ] GitHub Pages يعمل
- [ ] الروابط في README صحيحة
- [ ] لا يوجد بيانات حساسة مكشوفة

## 📋 قائمة التحقق النهائية
- [ ] Backup created
- [ ] New files added
- [ ] Temp files removed
- [ ] Git history cleaned
- [ ] Pushed to GitHub
- [ ] GitHub Pages working

## 🆘 في حالة مشكلة
```bash
# للتراجع عن التغييرات
git reset --hard HEAD~1

# أو استرجاع من الـ backup
git checkout backup-before-cleanup
```
