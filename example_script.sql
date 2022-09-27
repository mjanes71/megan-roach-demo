CREATE TYPE income AS ENUM (
    'Less than $40k',
    '$40-75k',
    '$75-125k',
    '$125k or more'
);

CREATE TYPE gender AS ENUM (
   'Male',
    'Female'
);

CREATE TYPE eduLevel AS ENUM (
   'College',
   'Some college',
    'High school or less'
);

CREATE TYPE voterType AS ENUM (
   'always',
   'sporadic',
    'rarely/never'
);

CREATE TABLE nonvoter_records (
    id INT PRIMARY KEY,
    education eduLevel, 
    race STRING,
    gender gender,
    income_category income,
    voter_category voterType
);

IMPORT INTO nonvoter_records (id, education, race, gender, income_category, voter_category) CSV DATA ('http://localhost:8000/non-voters/nonvoters_data.csv') WITH skip = '1';