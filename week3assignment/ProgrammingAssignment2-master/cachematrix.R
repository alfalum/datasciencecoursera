## Put comments here that give an overall description of what your
## functions do

## ## This function creates a special "matrix" object that can cache its inverse

makeCacheMatrix <- function(x = matrix()) {
  makeCacheMatrix <- function(x = matrix()) { 
    inv <- NULL                             ## inv as NULL 
    set <- function(y) {                    ##  set function to assign 
      x <<- y                             ## value of matrix
      inv <<- NULL                        ## new matrix, reset inv to NULL
    }
    get <- function() x                     ##  get fucntion returns value of the matrix 
    
    setinverse <- function(inverse) inv <<- inverse  ## assigns value of inv
    getinverse <- function() inv                     ## gets the value of inv where called
    list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}


## This function computes the inverse of the special "matrix" returned by makeCacheMatrix above.
  ## If the inverse has already been calculated (and the matrix has not changed),
  ## then cacheSolve will retrieve the inverse from the cache

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  inv <- x$getinverse()
  if(!is.null(inv)) {
    message("getting cached data")
    return(inv)
  }
  data <- x$get()
  inv <- solve(data, ...)
  x$setinverse(inv)
  inv
  }
