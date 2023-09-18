CREATE TABLE category
(
    id            BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    category_name VARCHAR(255),
    CONSTRAINT pk_category PRIMARY KEY (id)
);

CREATE TABLE business
(
    id                  BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    firebase_uid        VARCHAR(255),
    name                VARCHAR(255),
    profile_picture_url VARCHAR(255),
    email               VARCHAR(255),
    phone_number        VARCHAR(255),
    address             VARCHAR(255),
    zip_code            VARCHAR(255),
    city                VARCHAR(255),
    district            VARCHAR(255),
    cuisine             VARCHAR(255),
    price_range         INTEGER,
    score               DOUBLE PRECISION,
    longitude           DOUBLE PRECISION,
    latitude            DOUBLE PRECISION,
    join_date           date,
    CONSTRAINT pk_business PRIMARY KEY (id)
);

CREATE TABLE business_category
(
    id          BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    business_id BIGINT,
    category_id BIGINT,
    CONSTRAINT pk_businesscategory PRIMARY KEY (id),
    CONSTRAINT fk_businesscategory_on_business FOREIGN KEY (business_id) REFERENCES business (id),
    CONSTRAINT fk_businesscategory_on_category FOREIGN KEY (category_id) REFERENCES category (id)
);

CREATE TABLE "user"
(
    id                  BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    firebase_uid        VARCHAR(255),
    email               VARCHAR(255),
    username            VARCHAR(255),
    full_name           VARCHAR(255),
    profile_picture_url VARCHAR(255),
    join_date           date,
    CONSTRAINT pk_user PRIMARY KEY (id)
);

