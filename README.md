# 👷 overburden  ⛏⛰︎ *.ೃ࿔⋆ ❯❯❯❯ ⛃:･°
earned value management dashboard for capital mining projects
> a simulated Power BI project modelling **earned value management (EVM)** reporting for a capital mining project. 

**dashboard demo**


https://github.com/user-attachments/assets/f0a0a978-f5bf-49b4-b5b7-66ad21c8b2ac


---


## project overview
this dashboard simulates a ~$720M capital project spread across 9 work packages (Mine Development, Process Plant Construction, Tailings Storage Facility, Underground Development, etc.) over a 24-month schedule; tracks classic EVM metrics (CPI, SPI, Cost Variance, Schedule Variance, and cost-at-completion forecasting) at both the project level and the individual work package level.

**key insight surfaced by the dashboard:** the project overall tracks close to plan (CPI 0.96, SPI 0.95), but two work packages are responsible for most of the slippage: Tailings Storage Facility is running badly over budget and behind schedule (CPI 0.74, SPI 0.78), while Commissioning is on-cost but significantly behind schedule (CPI 1.03, SPI 0.65).


## tech stack
- **SQL**: generated the simulated raw cost dataset (monthly BCWS/BCWP/ACWP by work package).
- **Power Query**: data cleaning and shaping.
- **DAX**: EVM calculations and forecasting measures.
- **Power BI**: star-schema data model, report, and dashboard.


## dashboard features
- project-wide KPI cards (SV%, CV%, SPI, CPI) with red/amber/green conditional formatting.
- cumulative cost performance S-curve (BCWS vs. BCWP vs. ACWP).
- work package breakdown table (CPI, SPI, EAC, VAC per work package).
- mobile-optimised layout.
- written insights callout summarising project health.


## data model
star schema with one fact table and two dimension tables:
- **Cost Performance** (fact): `month_number`, `wbs_code`, `Date`, `BCWS`, `BCWP`, `ACWP`.
- **Calendar** (dimension): `Date`, `Month`, `Month name`, `Quarter`, `Year-Month`.
- **Work Packages** (dimension): `Work Package Code`, `Work Package Name`, `Total Budget`, `Cost Performance Target`, `Schedule Performance Target`.
<img width="1858" height="846" alt="image" src="https://github.com/user-attachments/assets/57a1ec06-367f-4a0e-a32d-4e5336c94a6c" />


## key DAX measures
```dax
Total BCWS = SUM('Cost Performance'[BCWS])
Total BCWP = SUM('Cost Performance'[BCWP])
Total ACWP = SUM('Cost Performance'[ACWP])

Cumulative BCWS =
CALCULATE(
    [Total BCWS],
    FILTER(ALL('Calendar'), 'Calendar'[Date] <= MAX('Calendar'[Date]))
)
-- Cumulative BCWP / ACWP follow the same pattern

Cost Variance (CV) = [Total BCWP] - [Total ACWP]
Schedule Variance (SV) = [Total BCWP] - [Total BCWS]
CPI = DIVIDE([Total BCWP], [Total ACWP])
SPI = DIVIDE([Total BCWP], [Total BCWS])

EAC = DIVIDE([Total Budget], [CPI])
VAC = [Total Budget] - [EAC]
```


## repository structure
```
mining-evm-dashboard/
├── README.md
├── sql/
│   └── generate_cost_data.sql
├── pbix/
│   └── mining-evm-dashboard.pbix
└── screenshots/
    ├── dashboard-desktop.png
    └── dashboard-mobile.png
```


## files
- **[SQL script](sql/generate_cost_data.sql)** — generates the simulated raw dataset
- **[.pbix file](pbix/mining-evm-dashboard.pbix)** — full Power BI model, DAX measures, and report (open in Power BI Desktop)

⣿⣿⣿⣿⣿⣟⠛⠛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠈⠙⢿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠸⣧⣀⣈⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣦⡀⠈⠛⠛⢿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⣹⣿⣦⡀⠀⠀⢻⣿⣷⠀⢠⣿⣿⡇⠀⠀⠀⣿
⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⣠⣾⣿⣿⣿⣷⣄⠀⠈⣿⣿⠀⣾⣿⣿⣿⠀⠀⠀⣿
⣿⣿⣿⣿⣿⠟⠁⠀⣠⣾⣿⣿⡟⠙⠻⣿⣿⣧⡀⢸⣿⣾⣿⣿⣿⣿⡆⠀⠀⣿
⣿⣿⣿⡟⠁⠀⣠⣾⣿⣿⣿⣿⣶⣦⣤⣤⣭⣿⣷⣼⣿⣿⣿⠋⠉⠁⠀⠀⠀⣿
⣿⡿⠋⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⣿
⣿⣿⣦⣾⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⠀⢸⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠼⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⣿
⣿⣿⣿⣿⠛⠛⠻⠿⢿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠉⠛⢻⣿⣿⣿⠟⠀⠀⠀⣿
⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⡏⠀⠀⠀⠀⣿
⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠂⠀⠀⠀⣿
⣿⣿⣿⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣿
