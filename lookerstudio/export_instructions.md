# Looker Studio Setup (with Year/Quarter slicers + color alerts)

Exports produced by the notebook (in `lookerstudio/`):
- `ev_share_by_yq.csv` — year, quarter, ev_share, threshold fields
- `rnd_ratio_by_company_yq.csv` — year, quarter, company, rnd_ratio, threshold fields
- `automation_vs_rnd_latest.csv` — latest quarter snapshot

## Steps
1) In Looker Studio → **Blank Report** → **Add Data** → choose **File Upload** (or **Google Sheets** if you push there).
2) Add **two controls**:
   - Drop-down for `year`
   - Drop-down for `quarter`
   Set them to affect all charts (or selected data sources).
3) Build charts:
   - Line: EV Share over Time (Dimension: `YearQuarterLabel` created as `CONCAT(CAST(year AS TEXT), " ", quarter)`; Metric: `ev_share_ok` and `ev_share_below`)
   - Bar: R&D Ratio by Company (Metrics: `rnd_ratio_ok` and `rnd_ratio_below`)
   - Scatter: Automation vs R&D (from `automation_vs_rnd_latest.csv`)
4) Colors:
   - Set `*_below` series to **red**
   - Set `*_ok` series to **green/neutral**
5) Publish and share link.

Tip: If you prefer Google Sheets (auto-refresh), use the “Publish to Sheets” cell in the notebook.
