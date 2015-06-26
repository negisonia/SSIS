CREATE OR REPLACE FUNCTION array_sort(anyarray) RETURNS anyarray AS $$
BEGIN
SELECT array_agg(x order by x) FROM unnest($1) x;
END
$$ LANGUAGE plpgsql;