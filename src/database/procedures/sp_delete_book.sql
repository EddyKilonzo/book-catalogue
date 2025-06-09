CREATE OR REPLACE FUNCTION sp_delete_book(
  p_id INTEGER
)
RETURNS VOID AS $$
BEGIN
  IF p_id IS NULL THEN
    RAISE EXCEPTION 'p_id cannot be null';
  END IF;

  DELETE FROM books
  WHERE books.id = p_id;

  RETURN;
EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'An error occurred: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

