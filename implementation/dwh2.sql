-- ========================================================
-- Date Dimension
-- ========================================================
CREATE TABLE dim_date (
    id         BIGINT PRIMARY KEY,
    full_date  DATE,
    year       BIGINT,
    month      BIGINT,
    day        BIGINT,
    quarter    VARCHAR(10)
);

-- ========================================================
-- Payments Dimension
-- ========================================================
CREATE TABLE dim_payments_FIN (
    id          BIGINT PRIMARY KEY,
    payment_id  BIGINT,
    status      VARCHAR(50),
    method      VARCHAR(50)
);

-- ========================================================
-- Accounts (CRM) with Composite Key
-- ========================================================
CREATE TABLE dim_accounts_CRM (
    customer_key    BIGINT NOT NULL,
    account_key     BIGINT NOT NULL,
    account_type    BIGINT,
    opened_date     DATE,
    status          VARCHAR(50),
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    email           VARCHAR(150),
    phone           VARCHAR(50),
    country         VARCHAR(100),
    CONSTRAINT pk_accounts PRIMARY KEY (customer_key, account_key)
);

-- ========================================================
-- Transactions Fact Table
-- ========================================================
CREATE TABLE fact_transactions_fin (
    id                  BIGINT PRIMARY KEY,
    transaction_id      BIGINT,
    payment_id          BIGINT FOREIGN KEY REFERENCES dim_payments_FIN(id),
    payment_date        BIGINT FOREIGN KEY REFERENCES dim_date(id),
    transaction_date    BIGINT FOREIGN KEY REFERENCES dim_date(id),
    customer_key        BIGINT,
    account_key         BIGINT,
    amount              DECIMAL(18,2),
    type                VARCHAR(50),
    description         VARCHAR(255),
    CONSTRAINT fk_customer_account FOREIGN KEY (customer_key, account_key)
        REFERENCES dim_accounts_CRM(customer_key, account_key)
);
