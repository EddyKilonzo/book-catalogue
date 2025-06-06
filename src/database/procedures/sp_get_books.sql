CREATE OR REPLACE FUNCTION sp_get_books()
 RETURNS SETOF books AS $$ 
    BEGIN
        RETURN QUERY
        SELECT * FROM books;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_get_books_by_publication_year(publication_year INT)
 RETURNS SETOF books AS $$ 
    BEGIN
        RETURN QUERY
        SELECT * FROM books WHERE publication_year = p_publication_year;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_get_books_by_author(author VARCHAR(250))
 RETURNS SETOF books AS $$ 
    BEGIN
        RETURN QUERY
        SELECT * FROM books WHERE author = p_author;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_get_books_by_title(title VARCHAR(250))
 RETURNS SETOF books AS $$ 
    BEGIN
        RETURN QUERY
        SELECT * FROM books WHERE title = p_title;
    END;
    $$ LANGUAGE plpgsql;