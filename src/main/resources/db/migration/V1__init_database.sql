DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS business CASCADE;
DROP TABLE IF EXISTS business_category CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS check_in CASCADE;
DROP TABLE IF EXISTS review CASCADE;
DROP TABLE IF EXISTS review_reply CASCADE;
DROP TABLE IF EXISTS attribute CASCADE;
DROP TABLE IF EXISTS business_attribute CASCADE;

CREATE TABLE category
(
    id            BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    name VARCHAR(255),
    CONSTRAINT pk_category PRIMARY KEY (id)
);

CREATE TABLE attribute
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    name VARCHAR(255),
    CONSTRAINT pk_attribute PRIMARY KEY (id)
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
    description         VARCHAR(255),
    type                VARCHAR(255),
    cost                VARCHAR(255),
    score               DOUBLE PRECISION,
    location_latitude   DOUBLE PRECISION,
    location_longitude  DOUBLE PRECISION,
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

CREATE TABLE business_attribute
(
    id          BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    business_id BIGINT,
    attribute_id BIGINT,
    CONSTRAINT pk_businessattribute PRIMARY KEY (id),
    CONSTRAINT fk_businessattribute_on_business FOREIGN KEY (business_id) REFERENCES business (id),
    CONSTRAINT fk_businessattribute_on_attribute FOREIGN KEY (attribute_id) REFERENCES attribute (id)
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

CREATE TABLE check_in
(
    id          BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    note        VARCHAR(255),
    user_id     BIGINT,
    business_id BIGINT,
    created_at  TIMESTAMP,
    CONSTRAINT pk_checkin PRIMARY KEY (id),
    CONSTRAINT fk_checkin_on_business FOREIGN KEY (business_id) REFERENCES business (id),
    CONSTRAINT fk_checkin_on_user FOREIGN KEY (user_id) REFERENCES "user" (id)
);

CREATE TABLE review_reply
(
    id          BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    description TEXT,
    created_at  TIMESTAMP,
    business_id BIGINT UNIQUE,
    CONSTRAINT pk_review_reply PRIMARY KEY (id),
    CONSTRAINT fk_reviewreply_on_business FOREIGN KEY (business_id) REFERENCES business (id)
);

CREATE TABLE review
(
    id          BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    score       INTEGER,
    description TEXT,
    created_at  TIMESTAMP,
    user_id     BIGINT,
    business_id BIGINT,
    review_reply_id BIGINT,
    CONSTRAINT pk_review PRIMARY KEY (id),
    CONSTRAINT fk_review_on_business FOREIGN KEY (business_id) REFERENCES business (id),
    CONSTRAINT fk_review_on_user FOREIGN KEY (user_id) REFERENCES "user" (id),
    CONSTRAINT fk_review_on_review_reply FOREIGN KEY (review_reply_id) REFERENCES review_reply (id)
);
