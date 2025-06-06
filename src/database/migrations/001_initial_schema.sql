/** creating books table **/
CREATE TABLE IF NOT EXISTS books(
    id SERIAL PRIMARY KEY,
    title VARCHAR(250) NOT NULL,
    author VARCHAR(250) NOT NULL,
    publication_year INT NOT NULL,
    isbn VARCHAR(250) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- indexes
CREATE INDEX IF NOT EXISTS idx_title ON books(title);
CREATE INDEX IF NOT EXISTS idx_author ON books(author);
CREATE INDEX IF NOT EXISTS idx_publication_year ON books(publication_year);
CREATE INDEX IF NOT EXISTS idx_isbn ON books(isbn);

-- procedure to count books by publication_year
CREATE OR REPLACE FUNCTION count_books_by_publication_year()
RETURNS TABLE(year INTEGER, count INTEGER) AS $$
BEGIN
    RETURN QUERY 
        SELECT publication_year AS year, COUNT(*) AS count
        FROM books
        GROUP BY publication_year
        ORDER BY publication_year;
END;
$$ LANGUAGE plpgsql;

-- procedure to add book
CREATE OR REPLACE FUNCTION add_book(
    title VARCHAR,
    author VARCHAR,
    publication_year INTEGER,
    isbn VARCHAR
) RETURNS INTEGER AS $$
DECLARE
    new_id INTEGER;
BEGIN
    INSERT INTO books (title, author, publication_year, isbn)
    VALUES (title, author, publication_year, isbn)
    RETURNING id INTO new_id;
    
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- procedure to delete book
CREATE OR REPLACE FUNCTION delete_book(
    book_id INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    rows_affected INTEGER;
BEGIN
    DELETE FROM books 
    WHERE id = book_id;
    
    GET DIAGNOSTICS rows_affected = ROW_COUNT;
    RETURN rows_affected > 0;
END;
$$ LANGUAGE plpgsql;

-- procedure to update book title
CREATE OR REPLACE FUNCTION update_book_title(
    book_id INTEGER,
    new_title VARCHAR
) RETURNS BOOLEAN AS $$
DECLARE
    rows_affected INTEGER;
BEGIN
    UPDATE books 
    SET title = new_title,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = book_id;
    
    GET DIAGNOSTICS rows_affected = ROW_COUNT;
    RETURN rows_affected > 0;
END;
$$ LANGUAGE plpgsql;