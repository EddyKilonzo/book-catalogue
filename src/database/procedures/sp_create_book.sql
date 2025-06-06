CREATE OR REPLACE FUNCTION sp_create_book(
    p_title VARCHAR(250),
    p_author VARCHAR(250),
    p_publication_year INT,
    p_isbn VARCHAR(250)
)
 RETURNS TABLE(id INTEGER, title VARCHAR(250), author VARCHAR(250), publication_year INT, isbn VARCHAR(250)) AS $$
    BEGIN
        IF EXISTS (SELECT 1 FROM books WHERE isbn = p_isbn) THEN
        RAISE EXCEPTION 'Book with ISBN % already exists', p_isbn;
        END IF;

        RETURN QUERY
        INSERT INTO books(title, author, publication_year, isbn)
        VALUES (p_title, p_author, p_publication_year, p_isbn)
        RETURNING id, title, author, publication_year, isbn;
    END;
    $$ LANGUAGE plpgsql;
