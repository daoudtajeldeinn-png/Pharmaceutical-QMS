# PharmaQMS - Total Pharmaceutical Quality Management System

## نظام إدارة الجودة الشاملة للأدوية

[![React](https://img.shields.io/badge/React-19.2.0-blue.svg)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.9.3-blue.svg)](https://www.typescriptlang.org/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()

A comprehensive, bilingual (Arabic/English) pharmaceutical quality management system built with modern web technologies.

---

## ✨ Features

### 🌐 Internationalization (i18n)
- **Bilingual Support**: Arabic (default) & English
- **Automatic RTL/LTR**: Direction switches based on language
- **Complete Translation**: All UI elements translated
- **Easy Switching**: One-click language toggle in header

### 📜 COA Manager (Certificate of Analysis)
- View and manage all certificates
- Professional print templates
- PDF export functionality
- Status tracking (Draft, Approved, Released)
- Search and filter capabilities
- Bilingual certificates

### 🏭 IPQC (In-Process Quality Control)
- Stage-wise quality monitoring
- Real-time Pass/Fail indicators
- 7 production stages tracking
- Comprehensive statistics dashboard
- Detailed check records
- Performance analytics

### 📊 Dashboard & Analytics
- Real-time statistics
- Activity monitoring
- Alert system
- Trend analysis
- Custom widgets

### 💊 Product Management
- Complete product catalog
- Specifications management
- Raw materials tracking
- Finished products
- Excipients database

### 🧪 Testing & Analysis
- Test results management
- Multiple test methods
- OOS (Out of Specification) handling
- Pharmacopeia standards
- HPLC, Dissolution, Assay tracking

### 📝 CAPA System
- Corrective actions
- Preventive actions
- Root cause analysis
- Effectiveness verification
- Audit trail

### ⚠️ Deviation Management
- Deviation reporting
- Investigation tracking
- Impact assessment
- Resolution workflow

### 🔧 Equipment Management
- Equipment inventory
- Calibration schedules
- Maintenance records
- Qualification tracking

### 🎓 Training & Competency
- Training records
- Competency assessment
- Certification tracking
- Course management

### 🔍 Audits & Compliance
- Audit planning
- Finding management
- CAPA integration
- Compliance tracking

### 📊 Reports & Analytics
- Custom reports
- Automated generation
- Export capabilities
- Data visualization

### 🛡️ Quality Systems
- GMP (Good Manufacturing Practice)
- GDP (Good Distribution Practice)
- GLP (Good Laboratory Practice)
- GSP (Good Storage Practice)
- ICH Guidelines
- FDA Compliance
- ISO Standards

---

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ and npm
- Modern web browser
- Internet connection (for initial setup)

### Installation

```bash
# Navigate to app directory
cd app

# Install dependencies
npm install

# Start development server
npm run dev
```

### Build for Production

```bash
npm run build
```

---

## 📁 Project Structure

```
PharmaQMS-Vue/
├── app/                          # Main application
│   ├── src/
│   │   ├── components/          # React components
│   │   │   ├── layout/          # Layout components
│   │   │   │   ├── Header.tsx
│   │   │   │   ├── Sidebar.tsx
│   │   │   │   └── LanguageSwitcher.tsx ✨
│   │   │   ├── ui/              # UI components (shadcn)
│   │   │   ├── dashboard/        # Dashboard widgets
│   │   │   ├── products/         # Product components
│   │   │   ├── testing/          # Testing components
│   │   │   └── security/         # Auth components
│   │   ├── pages/               # Page components
│   │   │   ├── Dashboard.tsx
│   │   │   ├── Products.tsx
│   │   │   ├── Testing.tsx
│   │   │   ├── IPQC.tsx
│   │   │   ├── COAManager.tsx   ✨ NEW
│   │   │   ├── CAPA.tsx
│   │   │   ├── Deviations.tsx
│   │   │   ├── Equipment.tsx
│   │   │   ├── Laboratory.tsx
│   │   │   ├── Training.tsx
│   │   │   ├── Audits.tsx
│   │   │   ├── Suppliers.tsx
│   │   │   ├── Reports.tsx
│   │   │   └── Settings.tsx
│   │   ├── hooks/               # Custom hooks
│   │   │   ├── useStore.ts
│   │   │   └── usePrintExport.tsx ✨ NEW
│   │   ├── locales/             # Translation files ✨ NEW
│   │   │   ├── ar/
│   │   │   │   └── translation.json
│   │   │   └── en/
│   │   │       └── translation.json
│   │   ├── lib/                 # Utilities
│   │   ├── types/               # TypeScript types
│   │   ├── i18n.ts             ✨ NEW
│   │   ├── App.tsx
│   │   ├── main.tsx
│   │   └── index.css
│   ├── public/                  # Static assets
│   ├── package.json
│   └── vite.config.ts
├── G2.html                      # Legacy reference
├── coq_manager_pro.py.py       # COA Manager reference
├── USER_GUIDE.md               ✨ NEW
├── QUICK_REFERENCE.md          ✨ NEW
└── README.md                   # This file

✨ = Recently added
```

---

## 🛠️ Technology Stack

### Frontend
- **React 19.2.0** - UI framework
- **TypeScript 5.9.3** - Type safety
- **Vite 7.2.4** - Build tool
- **Tailwind CSS 3.4** - Styling
- **shadcn/ui** - Component library

### Internationalization
- **i18next** - Translation framework
- **react-i18next** - React integration
- **i18next-browser-languagedetector** - Auto language detection

### Printing & Export
- **jsPDF** - PDF generation
- **html2canvas** - HTML to canvas conversion
- **react-to-print** - Print functionality

### Routing & State
- **React Router DOM 7.13** - Routing
- **Custom Context** - State management

### UI Components
- **Radix UI** - Accessible components
- **Lucide React** - Icons
- **Recharts** - Charts
- **React Hook Form** - Forms
- **Zod** - Validation

---

## 📖 Documentation

- **[User Guide](USER_GUIDE.md)** - Complete user documentation (Arabic/English)
- **[Quick Reference](QUICK_REFERENCE.md)** - Quick access guide
- **[Implementation Plan](.agent/IMPLEMENTATION_PLAN.md)** - Development roadmap
- **[Progress Report](.agent/PROGRESS_REPORT.md)** - Current status

---

## 🌟 Key Enhancements (February 2026)

### Recently Added Features

1. **✅ Complete Bilingual Support**
   - Arabic (default) and English
   - RTL/LTR automatic switching
   - Comprehensive translations
   - Language switcher in header

2. **✅ COA Manager**
   - Full certificate management
   - Professional print templates
   - PDF export functionality
   - Status workflow
   - Search and filtering

3. **✅ Enhanced Navigation**
   - Updated sidebar menu
   - Logical module organization
   - Visual icons for clarity
   - Breadcrumb support

4. **✅ Print & Export Infrastructure**
   - Reusable print hook
   - PDF generation utility
   - Multi-page support
   - Custom page sizes

5. **✅ Improved User Experience**
   - Responsive design
   - Touch-friendly interface
   - Loading states
   - Error handling

---

## 🎯 Upcoming Features

### Planned Enhancements

- [ ] Universal PDF export for all modules
- [ ] Advanced product templates
- [ ] Enhanced workflow visualization
- [ ] Automated notifications
- [ ] Advanced search with filters
- [ ] Data analytics dashboards
- [ ] Mobile app companion
- [ ] API integration
- [ ] Advanced reporting engine
- [ ] Blockchain for audit trail

---

## 📱 Browser Support

| Browser | Version | Status |
|---------|---------|--------|
| Chrome | Latest | ✅ Recommended |
| Edge | Latest | ✅ Supported |
| Firefox | Latest | ✅ Supported |
| Safari | Latest | ✅ Supported |

---

## 🔒 Security Features

- ✅ Role-based access control
- ✅ Audit trail for all actions
- ✅ Data encryption
- ✅ Session management
- ✅ Input validation
- ✅ CSRF protection

---

## 📊 System Requirements

### Minimum
- **Processor:** Dual-core 2.0 GHz
- **RAM:** 4 GB
- **Storage:** 500 MB free space
- **Browser:** Chrome 90+
- **Display:** 1366x768

### Recommended
- **Processor:** Quad-core 3.0 GHz
- **RAM:** 8 GB
- **Storage:** 2 GB free space
- **Browser:** Chrome latest
- **Display:** 1920x1080 or higher

---

## 🤝 Contributing

This is a proprietary system. For contributions or issues, contact the development team.

---

## 📞 Support

### Technical Support
- **Developer:** Dr. Daoud Tajeldeinn Ahmed
- **Email:** [Contact through system]
- **Documentation:** See USER_GUIDE.md

### For Users
- **Help Button:** Click ? in header
- **User Guide:** Comprehensive documentation available
- **Quick Reference:** QUICK_REFERENCE.md

---

## 📜 License

© 2024-2026 All Rights Reserved
Proprietary Software - Pharmaceutical Quality Management

This software is protected by copyright law and international treaties. Unauthorized reproduction or distribution may result in civil and criminal penalties.

---

## 🙏 Acknowledgments

- React Team for the amazing framework
- shadcn for beautiful UI components
- Radix UI for accessible primitives
- i18next team for internationalization
- All contributors and testers

---

## 📝 Version History

### Version 4.0 (February 2026) - Current
- ✨ Added complete bilingual support (Arabic/English)
- ✨ Implemented COA Manager with print/PDF export
- ✨ Enhanced IPQC module
- ✨ Added language switcher
- ✨ Improved navigation structure
- ✨ Created comprehensive documentation
- 🐛 Fixed various bugs
- ⚡ Performance improvements

### Version 3.0 (January 2026)
- Initial release with core QMS functionality
- Product management
-Testing and analysis
- CAPA system
- Deviation management
- Equipment tracking

---

## 📧 Contact

**System Developer:**
Dr. Daoud Tajeldeinn Ahmed

**Organization:**
[Your Organization Name]

**Location:**
[Your Location]

---

**Made with ❤️ for Pharmaceutical Quality**

**صُنع بحب من أجل جودة الأدوية  ❤️**

---

*Last Updated: February 4, 2026*
