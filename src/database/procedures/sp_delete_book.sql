CREATE OR REPLACE FUNCTION sp_delete_book(
  p_id INTEGER
)
RETURNS VOID AS $$
DECLARE
  rows_affected INTEGER;
BEGIN
  IF p_id IS NULL THEN
    RAISE EXCEPTION 'Book ID cannot be null';
  END IF;

  DELETE FROM books
  WHERE id = p_id;
  
  GET DIAGNOSTICS rows_affected = ROW_COUNT;
  
  IF rows_affected = 0 THEN
    RAISE EXCEPTION 'Book with ID % does not exist', p_id;
  END IF;
  
  RETURN;
EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Failed to delete book with ID %: %', p_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;