/** creating books table **/

CREATE  TABLE books(
    id SERIAL PRIMARY KEY,
    title VARACHAR(250) NOT NULL,
    author VARACHAR(250) NOT NULL,
    publication_year INT NOT NULL,
    isbn VARACHAR(250)  unique
);

-- indexes

CREATE INDEX IF NOT EXISTS idx_title ON books(title);
CREATE INDEX IF NOT EXISTS idx_author ON books(author);
CREATE INDEX IF NOT EXISTS idx_publicatio_year ON books(publication_year);
CREATE INDEX IF NOT EXISTS idx_isbn ON books(isbn);

-- procedure to count books by publicatio_year

CREATE OR REPLACE FUNCTION count_books_by_publication_year()
 RETURNS TABLE(year INTEGER, count INTEGER) AS  $$
 BEGIN
    RETURN QUERY 
        SELECT publication_year AS year, count(*) AS count
        FROM booksNew chat
        Today
        Build a basic Book Catalog API u
        How to Change Git Branches Guide
        
        GROUP BY publication_year;
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
    BEGIN
      INSERT INTO books (title, author, publication_year, isbn)
      VALUES (title, author, publication_year, isbn)
      RETURNING id;
    END;
    $$ LANGUAGE plpgsql;

    --procedure to delete book
    CREATE OR REPLACE FUNCTION delete_book(
      book_id INTEGER
    )


--- procedure to update book title
 CREATE OR REPLACE FUNCTION update_book_title(
      book_id INTEGER,
      new_title VARCHAR
    ) RETURNS BOOLEAN AS $$
    DECLARE
      rows_affected INTEGER;
    BEGIN
      UPDATE books 
      SET title = new_title 
      WHERE id = book_id;
      
      GET DIAGNOSTICS rows_affected = ROW_COUNT;
      RETURN rows_affected > 0;
    END;
    $$ LANGUAGE plpgsql;

--- procedure to update book author
 CREATE OR REPLACE FUNCTION update_book_author(
      book_id INTEGER,
      author_id INTEGER
    ) RETURNS BOOLEAN AS $$
    DECLARE
      rows_affected INTEGER;
    BEGIN
      UPDATE books 
      SET author_id = author_id 
      WHERE id = book_id;
      
      GET DIAGNOSTICS rows_affected = ROW_COUNT;
      RETURN rows_affected > 0;
    END;
    $$ LANGUAGE plpgsql;

