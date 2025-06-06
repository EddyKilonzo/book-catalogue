CREATE OR REPLACE FUNCTION sp_delete_book(P_id INTEGER)
RETURNS TABLE (
    success BOOLEAN,
    message  TEXT,
    title VARCHAR(250)
    
) AS $$
   DECLARE 
    current_title VARCHAR(250);
    BEGIN
        SELECT book.title INTO current_title FROM book WHERE book.id = P_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Book with ID % does not exist', P_id;
        END IF;

        DELETE FROM book WHERE book.id = P_id;

        RETURN QUERY
        SELECT TRUE AS success, 'Book deleted successfully' AS message, current_title AS title;
    END;
    $$ LANGUAGE plpgsql;
    