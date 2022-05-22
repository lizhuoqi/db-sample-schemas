
--
-- blob field
--

alter table staff add column picture blob;

-- 
-- SET type
--

alter table film modify column special_features 
SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes');
