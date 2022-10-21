# megan-roach-demo

This example script was created to perform a cockroachdb demo for Cincinnati Women Who Code. The csv data was borrowed from the [FiveThirtyEight story "Why Millions of Americans Don't Vote."](https://data.fivethirtyeight.com/)

Here is the [google slideshow](https://docs.google.com/presentation/d/1IvJ0UYOfLfKyjycb73CazJpyVjmGarbZ4hT_-tIkdmA/edit?usp=sharing) that was used to facilitate the presentation for your reference. 

Cheers! 😀

## Basic Cockroach Commands
**Install Cockroach**
* Mac
```
brew install cockroachdb/tap/cockroach
```
* Windows
```
curl https://binaries.cockroachdb.com/cockroach-v22.1.7.darwin-10.9-amd64.tgz | tar -xJ && cp -i cockroach-v22.1.7.darwin-10.9-amd64/cockroach /usr/local/bin/

```

**Run Cockroach**
```
cockroach start-single-node --insecure --listen-addr=localhost:26257 --http-addr=localhost:8080
```

**Query Local Cockroach**
```
cockroach sql --url ‘postgresql://root@localhost:26257/defaultdb?sslmode=disable’
```

**Stop Local Cockroach**
```
Ctrl+c
rm -r cockroach-data
```
