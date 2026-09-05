# Superstore Discount vs. Profit Analysis

Retail analytics project examining the relationship between discount levels and profitability using the Superstore dataset (2014–2017). Built with MySQL, Python, and Power BI.

## 🎯 Objective

Determine which discount levels help profit, which hurt it, and what discount policy the business should adopt — supported by evidence, not assumption.

## 📊 Key Findings

- **9,694 orders** analyzed across **2014–2017**
- Total Sales: **$2.27M** | Total Profit: **$282,858** | Overall Margin: **12.45%**
- Discount bands **0–20%** all produce positive margins (29.57% down to 11.58%)
- Discount bands **above 20%** run a loss without exception:
  - 21–30% discount → **-10.05%** margin
  - 31%+ discount → **-47.94%** margin
- Loss-making orders total **-$154,511** — more than half of total profit
- Four states drive the majority of losses: **Texas, Ohio, Pennsylvania, Illinois** — each averaging 30%+ discounts

## 🗂️ Repository Structure

superstore-discount-profit-analysis/
├── README.md
├── data/
│ └── superstore_cleaned.csv # Cleaned dataset (standardized dates, trimmed whitespace)
├── sql/
│ └── superstore_analysis.sql # MySQL schema, cleaning, and 7 analytical queries
├── notebooks/
│ └── Superstore.ipynb # Python analysis: correlation, elasticity, RFM, Pareto
├── powerbi/
│ └── SuperStore.pbix # 6-page interactive dashboard
└── docs/
└── Project_Roadmap.docx # Project scope, methodology, deliverables


## 🛠️ Tools Used

- **MySQL** — data cleaning, discount tier segmentation, regional/state/customer profit queries
- **Python (pandas, matplotlib/seaborn)** — correlation analysis, price elasticity simulation, RFM segmentation, Pareto analysis
- **Power BI** — 6-page interactive dashboard with drill-downs and dynamic recommendations

## 📈 Dashboard Pages

1. **Executive Overview** — top-line KPIs and the discount cliff
2. **Geography (Where)** — regional and state-level profit drain
3. **Product (What)** — category and sub-category performance
4. **Discount & Elasticity (How Much)** — correlation, elasticity, cap simulation
5. **Customers & Fulfillment (Who + Time)** — account-level leakage, shipping efficiency
6. **Recommendations** — governance policy and evidence-based action items

## ✅ Recommendations

- Cap discounts at 20% at checkout
- Review top loss-making customer accounts individually
- Audit discount approval practices in Texas, Ohio, Pennsylvania, and Illinois first

## ⚠️ Scope Note

This analysis is based on 2014–2017 data only. No claims are made about years outside this range.

## 📬 Contact

Built by Tanuja — feel free to open an issue or reach out with questions.

