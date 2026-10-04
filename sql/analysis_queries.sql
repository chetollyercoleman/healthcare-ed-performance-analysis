-- Query 1: Score Coverage by State and Measure
SELECT
  state,
  measure_id,
  start_date,
  end_date,
  COUNT(DISTINCT facility_id) AS hospitals_with_records,
  COUNT(hospital_score) AS hospitals_with_available_scores,
  COUNTIF(hospital_score IS NULL) AS hospitals_with_unavailable_scores,
  ROUND(
    100.0 * SAFE_DIVIDE(
      COUNT(hospital_score),
      COUNT(*)
    ),
    1
  ) AS percent_with_available_scores
FROM
  `practice-projects-509919.healthcare_ed.ed_analysis`
GROUP BY
  state,
  measure_id,
  start_date,
  end_date
ORDER BY
  measure_id,
  state;

-- Query 2: Hospitals Above State Benchmark
SELECT
  state,
  measure_id,
  score_unit,
  start_date,
  end_date,
  COUNT(*) AS hospitals_with_records,
  COUNT(above_state_flag) AS hospitals_with_comparable_scores,
  COUNTIF(above_state_flag IS NULL)
    AS hospitals_without_comparable_scores,
  COUNTIF(above_state_flag = 1)
    AS hospitals_above_state_benchmark,
  ROUND(
    100.0 * SAFE_DIVIDE(
      COUNTIF(above_state_flag = 1),
      COUNT(above_state_flag)
    ),
    1
  ) AS percent_above_state_benchmark
FROM
  `practice-projects-509919.healthcare_ed.ed_analysis`
GROUP BY
  state,
  measure_id,
  score_unit,
  start_date,
  end_date
ORDER BY
  measure_id,
  state;

-- Query 3: Largest Hospital Benchmark Gaps
WITH ranked_hospitals AS (
  SELECT
    facility_id,
    facility_name,
    state,
    county_parish,
    hospital_type,
    hospital_ownership,
    measure_id,
    start_date,
    end_date,
    hospital_score,
    state_benchmark,
    ROUND(difference_from_state, 2) AS difference_from_state,

    CASE
      WHEN measure_id = 'OP_18b' THEN 'Minutes'
      WHEN measure_id = 'OP_22' THEN 'Percentage points'
    END AS difference_unit,

    ROW_NUMBER() OVER (
      PARTITION BY measure_id, start_date, end_date
      ORDER BY difference_from_state DESC, facility_id
    ) AS review_rank

  FROM
    `practice-projects-509919.healthcare_ed.ed_analysis`

  WHERE above_state_flag = 1
)

SELECT *
FROM ranked_hospitals
WHERE review_rank <= 10
ORDER BY measure_id, review_rank;

-- Query 4: Comparisons by Hospital Type
SELECT
  state,
  hospital_type,
  measure_id,
  start_date,
  end_date,

  COUNT(*) AS hospitals_with_records,

  COUNT(above_state_flag)
    AS hospitals_with_comparable_scores,

  COUNTIF(above_state_flag IS NULL)
    AS hospitals_without_comparable_scores,

  COUNTIF(above_state_flag = 1)
    AS hospitals_above_state_benchmark,

  ROUND(
    100.0 * SAFE_DIVIDE(
      COUNTIF(above_state_flag = 1),
      COUNT(above_state_flag)
    ),
    1
  ) AS percent_above_state_benchmark

FROM
  `practice-projects-509919.healthcare_ed.ed_analysis`

GROUP BY
  state,
  hospital_type,
  measure_id,
  start_date,
  end_date

ORDER BY
  measure_id,
  state,
  percent_above_state_benchmark DESC,
  hospital_type;

-- Query 5: Comparisons by Hospital Ownership
SELECT
  state,
  hospital_ownership,
  measure_id,
  start_date,
  end_date,

  COUNT(*) AS hospitals_with_records,

  COUNT(above_state_flag)
    AS hospitals_with_comparable_scores,

  COUNTIF(above_state_flag IS NULL)
    AS hospitals_without_comparable_scores,

  COUNTIF(above_state_flag = 1)
    AS hospitals_above_state_benchmark,

  ROUND(
    100.0 * SAFE_DIVIDE(
      COUNTIF(above_state_flag = 1),
      COUNT(above_state_flag)
    ),
    1
  ) AS percent_above_state_benchmark

FROM
  `practice-projects-509919.healthcare_ed.ed_analysis`

GROUP BY
  state,
  hospital_ownership,
  measure_id,
  start_date,
  end_date

ORDER BY
  measure_id,
  state,
  percent_above_state_benchmark DESC,
  hospital_ownership;

-- Query 6: Comparisons by County/Parish
SELECT
  state,
  NULLIF(TRIM(county_parish), '') AS county_parish,
  measure_id,
  start_date,
  end_date,

  COUNT(DISTINCT facility_id) AS hospitals_with_records,

  COUNT(above_state_flag)
    AS hospitals_with_comparable_scores,

  COUNTIF(above_state_flag IS NULL)
    AS hospitals_without_comparable_scores,

  COUNTIF(above_state_flag = 1)
    AS hospitals_above_state_benchmark,

  ROUND(
    100.0 * SAFE_DIVIDE(
      COUNTIF(above_state_flag = 1),
      COUNT(above_state_flag)
    ),
    1
  ) AS percent_above_state_benchmark

FROM
  `practice-projects-509919.healthcare_ed.ed_analysis`

GROUP BY
  state,
  county_parish,
  measure_id,
  start_date,
  end_date

ORDER BY
  measure_id,
  percent_above_state_benchmark DESC,
  hospitals_with_comparable_scores DESC,
  state,
  county_parish;
