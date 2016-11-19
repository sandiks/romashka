# romashka
   INFO -  (0.000622s) SELECT * FROM "forums" WHERE (("siteid" = 10) AND ("fid" = '287')) LIMIT 1
   INFO -  (0.001222s) SELECT * FROM "threads" WHERE (("fid" = '287') AND ("siteid" = 10) AND (updated > '2016-11-18 12:13:26.511279+0300')) ORDER BY "updated" DESC
  DEBUG -  TEMPLATE (0.0012s) /forum/show
  DEBUG -  TEMPLATE (0.0003s) /layouts/application
  DEBUG -  TEMPLATE (0.0005s) /shared/_forums
  DEBUG -       GET (0.3981s) /fpda/forum/show/287 - 200 OK
