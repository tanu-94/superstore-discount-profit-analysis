# 📊 Superstore Discount vs. Profit Analysis

<p align="center">
  <img src="./Images/EOV.png" alt="Superstore Executive Overview Dashboard" width="100%">
</p>

<p align="center">
  <strong>
    An end-to-end retail analytics project investigating how discount strategies
    impact profitability using MySQL, Python, and Power BI.
  </strong>
</p>

<p align="center">

  <img src="https://img.shields.io/badge/MySQL-Data%20Analysis-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL">

  <img src="https://img.shields.io/badge/Python-Analytics-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python">

  <img src="https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" alt="Power BI">

  <img src="https://img.shields.io/badge/Status-Completed-success?style=for-the-badge" alt="Project Status">

</p>

---

# 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Business Objective](#-business-objective)
- [Key Business Questions](#-key-business-questions)
- [Key Findings](#-key-findings)
- [Project Workflow](#-project-workflow)
- [Repository Structure](#-repository-structure)
- [Tools & Technologies](#-tools--technologies)
- [Data Preparation](#-data-preparation)
- [SQL Analysis](#-sql-analysis)
- [Python Analysis](#-python-analysis)
- [Power BI Dashboard](#-power-bi-dashboard)
- [Business Recommendations](#-business-recommendations)
- [Scope & Limitations](#-scope--limitations)
- [Future Improvements](#-future-improvements)
- [Author](#-author)

---

# 🔍 Project Overview

Discounts are widely used by retail businesses to attract customers and increase sales. However, higher sales do not always translate into higher profits.

This project analyzes the **relationship between discount levels and profitability** using Superstore retail data from **2014–2017**.

The analysis investigates:

- 📉 How increasing discounts affect profit margins
- 💰 Which discount levels remain profitable
- 🚨 Where profit leakage occurs
- 🗺️ Which states contribute most to losses
- 📦 Which products and categories require attention
- 👥 Which customers contribute disproportionately to losses
- 🎯 What discount policy the business should adopt

The goal is to transform raw transaction data into **clear, evidence-based business recommendations**.

---

# 🎯 Business Objective

> **Determine which discount levels support profitability, which discount levels create losses, and what discount policy the business should adopt.**

The project focuses on identifying the point at which discounts stop supporting profitable growth and begin destroying margins.

---

# ❓ Key Business Questions

## 💸 Discount Analysis

1. How does profit change as discount levels increase?
2. Which discount levels consistently generate positive margins?
3. At what point do discounts begin to create losses?
4. Is there a practical discount threshold for the business?

## 🗺️ Geographic Analysis

5. Which regions and states generate the highest losses?
6. Where should discount policies be reviewed first?

## 📦 Product Analysis

7. Which categories and sub-categories generate the strongest profits?
8. Which products are most affected by discounting?

## 👥 Customer Analysis

9. Which customers contribute most to profit leakage?
10. Can customer segmentation help improve discount decisions?

## 🎯 Business Strategy

11. What actions can reduce profit leakage?
12. What discount governance policy should the company implement?

---

# 📊 Key Findings

## 🛒 Orders Analyzed

### **9,694 Orders**

📅 **Analysis Period:** 2014–2017

---

## 💰 Overall Business Performance

| Metric | Value |
|---|---:|
| Total Sales | **$2.27M** |
| Total Profit | **$282,858** |
| Overall Profit Margin | **12.45%** |
| Orders Analyzed | **9,694** |

---

## 📉 The Discount Cliff

The analysis reveals a clear relationship between discount levels and profitability.

| Discount Range | Profit Performance |
|---|---|
| **0–10%** | Strong positive margin |
| **11–20%** | Positive margin |
| **21–30%** | 🔴 Negative margin |
| **31%+** | 🔴 Severe losses |

### Key Results

- **0–20% discount bands remain profitable**
- **21–30% discount → -10.05% profit margin**
- **31%+ discount → -47.94% profit margin**

> ### 🚨 Key Insight
>
> **Discounts above 20% consistently generate losses in this dataset.**

This creates a clear **discount cliff**, where additional discounting no longer supports profitable growth.

---

## 🚨 Profit Leakage

Loss-making orders generated:

# **-$154,511**

in total losses.

This represents a substantial amount of profit leakage and highlights the importance of controlling excessive discounting.

---

## 🗺️ High-Loss States

Four states contribute heavily to overall losses:

- Texas
- Ohio
- Pennsylvania
- Illinois

These states show a combination of:

- Higher discount levels
- Negative profitability
- Significant loss-making orders

### Business Opportunity

These markets should be prioritized for:

- Discount policy audits
- Approval controls
- Customer-level reviews
- Product pricing evaluation

---

# 🔄 Project Workflow

```text
                         Raw Superstore Data
                                  │
                                  ▼
                    Data Cleaning & Preparation
                                  │
                                  ▼
                 ┌──────────────────────────┐
                 │     Exploratory Analysis │
                 └────────────┬─────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
          MySQL Analysis   Python Analysis   Power BI
              │               │               │
              │               │               │
              ▼               ▼               ▼
       Business Queries   Advanced Analytics  Dashboard
              │               │               │
              └───────────────┼───────────────┘
                              │
                              ▼
                     Business Insights
                              │
                              ▼
                    Recommendations & Policy
