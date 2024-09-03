# ray_one - WIP
Raytracing in a weekend - Book One

PLEASE NOTE: This is a work in progress, about 50% of the way through the book so far

# Overview
Odin is a programming language that is similar to C and very well suited to graphics programming.
I am going through the Raytracing in a weekend book(s) in an effort to try out this language. This is a first attempt, so not 
being used to the language and what is idiomatic, the result is a little haphazard. I will likely need to revisit this and
do some refactoring once I understand the language a bit better.

# Raytracer

The following image was produced using a value for samples_per_pixel of 500. This will give a high quality
render, but will be very slow.

![Alt text](images/test_image.jpg)

# Build and run 

This requires Odin to be setup on your machine with the appropriate paths added to the appropriate locations for your machine.
I have tested this on Mac M1 and Windows PC - I expect it will work fine on Linux too.

Clone the repo:

```
git clone https://github.com/cainmartin/ray_one.git
```

Navigate to the root folder and run the Odin compiler

```
cd ray_one
odin run src
```

# Odin

## Thoughts on Odin-Lang

What I liked:
- I really like the build system, it's simple and easy to get going
- Compilation is REALY fast
- Compile time execution is really cool - I need to dig into this more, but it seems realy powerful
- Multiple return values are useful and super nice
- The batteries included nature of the maths / graphics libraries is just awesome

What I didn't like:
- Sometimes Odin just fails silently, I had a few times the compiler would just not run the build with no errors
- Some of the syntax takes some getting used to (this is a skill issue mostly)

I enjoyed Odin a lot. It is very C like, it is a pretty ergonomic language, and had some really nice features.

There is a lot of friction going into it though, because the documentation is not great and some of the concepts are
not obvious or seem to have multiple ways of achieving the same goal. So it can be hard to work out what is idiomatic 
code in Odin. You are often left with the feeling that you might be creating a rod for your own back with decisions
you make now, due to a lack of guidance.

I do find C a much simpler language to grok - but Odin is REALLY good. It's easy to use, build process is simple and
it's really powerful. I will come back to this language.


Odin can be found here:

https://odin-lang.org