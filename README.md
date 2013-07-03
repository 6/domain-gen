#### Dictionary-based usage

```
ruby domaingen.rb --type=dictionary --domain-prefix=hello
```

```
helloability.com available
helloable.com unavailable
helloaboard.com available
helloabout.com unavailable
helloabove.com unavailable
...
```

#### Character permutation-based usage

```
ruby domaingen.rb --type=permutation --domain-suffix=hello --permutation-length=2
```

```
aahello.com unavailable
abhello.com available
achello.com available
adhello.com unavailable
aehello.com available
...
```
