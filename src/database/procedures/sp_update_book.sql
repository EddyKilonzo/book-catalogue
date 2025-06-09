CREATE or REPLACE FUNCTION sp_update_book(
    p_id INTEGER,
    p_title VARCHAR(250) DEFAULT NULL,
    p_author VARCHAR(250) DEFAULT NULL,
    p_publication_year INTEGER DEFAULT NULL,
    p_isbn VARCHAR(250) DEFAULT NULL
)
RETURNS TABLE(id INTEGER, title VARCHAR(250), author VARCHAR(250), publication_year INTEGER, isbn VARCHAR(250)) AS $$
    DECLARE
    current_title VARCHAR(250);
    current_author VARCHAR(250);
    current_publication_year INTEGER;
    current_isbn VARCHAR(250);
    BEGIN
        SELECT books.isbn INTO current_isbn FROM books WHERE books.id = p_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Book with ID % does not exist', p_id;
        END IF;

        IF p_isbn IS NOT NULL AND p_isbn != current_isbn THEN
            IF EXISTS (SELECT 1 FROM books WHERE isbn = p_isbn) THEN
                RAISE EXCEPTION 'Book with ISBN % already exists', p_isbn;
            END IF;
        END IF;

        RETURN QUERY
        UPDATE books
        SET title = COALESCE(p_title, books.title),
            author = COALESCE(p_author, books.author),
            publication_year = COALESCE(p_publication_year, books.publication_year),
            isbn = COALESCE(p_isbn, books.isbn)
        WHERE books.id = p_id
        RETURNING books.id, books.title, books.author, books.publication_year, books.isbn;
    END;
$$ LANGUAGE plpgsql;

