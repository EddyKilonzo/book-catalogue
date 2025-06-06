CREATE or REPLACE FUNCTION dp_update_book(
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
        SELECT book.isbn INTO current_isbn FROM book WHERE book.id = p_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Book with ID % does not exist', p_id;
        END IF;

        IF p_title IS NOT NULL AND p_isbn != current_isbn THEN
            IF EXISTS (SELECT 1 FROM book WHERE isbn = p_isbn) THEN
                RAISE EXCEPTION 'Book with ISBN % already exists', p_isbn;
            END IF;
        END IF;

        RETURN QUERY
        UPDATE book
        SET title = COALESCE(p_title, title),
            author = COALESCE(p_author, author),
            publication_year = COALESCE(p_publication_year, publication_year),
            isbn = COALESCE(p_isbn, isbn)
        WHERE id = p_id
        RETURNING book.id, book.title, book.author, book.publication_year, book.isbn;
    END;
    $$ LANGUAGE plpgsql;
