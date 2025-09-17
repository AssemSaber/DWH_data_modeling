-- ========================================================
-- ERP Schema
-- ========================================================
CREATE TABLE dim_products_ERP (
    product_id       BIGINT PRIMARY KEY,
    product_name     VARCHAR(255),
    category_name    VARCHAR(255),
    brand_name       VARCHAR(255),
    warehouse_name   VARCHAR(255),
    stock_level      BIGINT,
    unit_price       DECIMAL(18,2),
    cost             DECIMAL(18,2)
);

CREATE TABLE dim_suppliers_orders (
    po_id           BIGINT PRIMARY KEY,
    supplier_id     BIGINT,
    status          VARCHAR(50),
    start_date      BIGINT,
    end_date        BIGINT,
    supplier_name   VARCHAR(255),
    contact_name    VARCHAR(255),
    phone           VARCHAR(50),
    country         VARCHAR(100)
);

CREATE TABLE fact_orders_erp (
    po_item_id      BIGINT PRIMARY KEY,
    product_id      BIGINT FOREIGN KEY REFERENCES dim_products_ERP(product_id),
    po_id           BIGINT FOREIGN KEY REFERENCES dim_suppliers_orders(po_id),
    order_date      BIGINT,
    quantity        BIGINT,
    new_column      DECIMAL(18,2)
);

-- ========================================================
-- Date Dimension
-- ========================================================
CREATE TABLE dim_date (
    date_id     BIGINT PRIMARY KEY,
    full_date   DATE,
    year        INT,
    month       INT,
    day         INT,
    quarter     VARCHAR(10)
);

-- ========================================================
-- Finance Schema
-- ========================================================
CREATE TABLE dim_cost_centers (
    center_id       BIGINT PRIMARY KEY,
    center_name     VARCHAR(255),
    department_name VARCHAR(255),
    department_id   BIGINT
);

CREATE TABLE fact_expenses_fin (
    expense_id      BIGINT PRIMARY KEY,
    center_id       BIGINT FOREIGN KEY REFERENCES dim_cost_centers(center_id),
    expense_date    BIGINT FOREIGN KEY REFERENCES dim_date(date_id),
    amount          DECIMAL(18,2)
);

CREATE TABLE fact_budgets_fin (
    budget_id       BIGINT PRIMARY KEY,
    center_id       BIGINT FOREIGN KEY REFERENCES dim_cost_centers(center_id),
    full_date       BIGINT FOREIGN KEY REFERENCES dim_date(date_id),
    allocated_amount DECIMAL(18,2)
);

-- ========================================================
-- HR Schema
-- ========================================================
CREATE TABLE dim_status_jun (
    jun_id              BIGINT PRIMARY KEY,
    leaves_status       VARCHAR(100),
    leaves_type         VARCHAR(100),
    training_result     VARCHAR(100),
    attendance_status   VARCHAR(100)
);

CREATE TABLE dim_employees_hr (
    employee_id     BIGINT PRIMARY KEY,
    first_name      VARCHAR(255),
    last_name       VARCHAR(255),
    job_title       VARCHAR(255),
    amount          DECIMAL(18,2),
    min_salary      DECIMAL(18,2),
    max_salary      DECIMAL(18,2),
    start_date      DATE,
    end_date        DATE,
    manager_name    BIGINT
);

CREATE TABLE bridge_department_employee (
    department_id   BIGINT,
    employee_id     BIGINT FOREIGN KEY REFERENCES dim_employees_hr(employee_id),
    PRIMARY KEY (department_id, employee_id)
);

CREATE TABLE dim_training_hr (
    training_id     BIGINT PRIMARY KEY,
    training_name   BIGINT
);

CREATE TABLE fact_attendance_hr (
    att_id          BIGINT PRIMARY KEY,
    jun_id          BIGINT FOREIGN KEY REFERENCES dim_status_jun(jun_id),
    employee_id     BIGINT FOREIGN KEY REFERENCES dim_employees_hr(employee_id),
    attendance_date BIGINT FOREIGN KEY REFERENCES dim_date(date_id)
);

CREATE TABLE fact_leaves_hr (
    leave_id        BIGINT PRIMARY KEY,
    employee_id     BIGINT FOREIGN KEY REFERENCES dim_employees_hr(employee_id),
    jun_id          BIGINT FOREIGN KEY REFERENCES dim_status_jun(jun_id),
    start_date      BIGINT FOREIGN KEY REFERENCES dim_date(date_id),
    end_date        BIGINT FOREIGN KEY REFERENCES dim_date(date_id)
);

CREATE TABLE fact_training_hr (
    training_id     BIGINT PRIMARY KEY,
    employee_id     BIGINT FOREIGN KEY REFERENCES dim_employees_hr(employee_id),
    training_id_fk  BIGINT FOREIGN KEY REFERENCES dim_training_hr(training_id),
    training_date   BIGINT FOREIGN KEY REFERENCES dim_date(date_id)
);
