# Setting up Containers  

## podman  
I'm going to start with podman since it is compatible with docker and cross platform to linux.  

[Podman Install Documentation](https://podman.io/docs/installation#installing-on-freebsd-140)  

I followed through the documentation but the Alpine Linux test at the end failed.  
I had to edit the config file to add `docker.io` as an unqualified search registry.  
[site with the fix](https://github.com/containers/podman/issues/16096)  

```bash
# file is called out in the error text 
vim /usr/local/etc/containers/registries.conf 
#search for unqualified-search-registries and add this line 
unqualified-search-registries = ["docker.io"] 
```

# jails

[Starting with the handbook](https://docs.freebsd.org/en/books/handbook/jails/)  

