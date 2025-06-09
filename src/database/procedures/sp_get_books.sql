CREATE OR REPLACE FUNCTION sp_get_books()
 RETURNS SETOF books AS $$ 
    BEGIN
        RETURN QUERY
        SELECT * FROM books;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_get_books_by_publication_year(p_publication_year INT)
RETURNS TABLE(id INTEGER, title VARCHAR(250), author VARCHAR(250), publication_year INT, isbn VARCHAR(250)) AS $$
BEGIN
    RETURN QUERY
    SELECT b.id, b.title, b.author, b.publication_year, b.isbn
    FROM books b
    WHERE b.publication_year = p_publication_year;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_get_books_by_author(p_author VARCHAR(250))
RETURNS TABLE(id INTEGER, title VARCHAR(250), author VARCHAR(250), publication_year INT, isbn VARCHAR(250)) AS $$
BEGIN
    RETURN QUERY
    SELECT b.id, b.title, b.author, b.publication_year, b.isbn
    FROM books b
    WHERE b.author = p_author;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_get_books_by_title(p_title VARCHAR(250))
RETURNS TABLE(
    id INTEGER, 
    title VARCHAR(250), 
    author VARCHAR(250), 
    publication_year INT, 
    isbn VARCHAR(250)) 
    AS $$
BEGIN
    RETURN QUERY
    SELECT b.id, b.title, b.author, b.publication_year, b.isbn
    FROM books b
    WHERE b.title = p_title;
END;
$$ LANGUAGE plpgsql;

