CREATE OR REPLACE FUNCTION sp_create_book(
    p_title VARCHAR(250),
    p_author VARCHAR(250),
    p_publication_year INT,
    p_isbn VARCHAR(250)
)
 RETURNS TABLE(id INTEGER, title VARCHAR(250), author VARCHAR(250), publication_year INT, isbn VARCHAR(250)) AS $$
    BEGIN
       IF EXISTS (SELECT 1 FROM books b WHERE b.title = p_title) THEN
        RAISE EXCEPTION 'Book with title "%" already exists', p_title;
    END IF;

    -- Insert the book and return inserted row
    RETURN QUERY
    INSERT INTO books (title, author, publication_year, isbn)
    VALUES (p_title, p_author, p_publication_year, p_isbn)
    RETURNING books.id, books.title, books.author, books.publication_year, books.isbn;
END;
$$ LANGUAGE plpgsql;