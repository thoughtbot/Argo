# Documentation #

Argo allows you to easily decode loosely typed structures into strongly typed
models. When paired with functional programming concepts, Argo becomes a
beautiful way to decode JSON from network responses into your application
models. The following guides will teach you how to use Argo and how powerful
it can be.

## High Level Concepts ##

- [Overarching ideology](Ideology.md)
- [Functional concepts](Functional-Concepts.md)

## Basic Usage ##

- Decoding your first model // TODO
- Using functional concepts to simplify the decoder // TODO

## Advanced Usage ##

- Understanding the Decode operators // TODO
- Interacting with the `JSON` enum // TODO
- Writing your own custom parser // TODO
- More complex parsers // TODO

## Known Issues ##

  You can encounter with issue like this [one](https://github.com/thoughtbot/Argo/issues/184). 
Due to limitations in the Swift compiler it can't handle more than 12 clauses in one expression.
For instance, if you have a model with more than 12 fields you should consider breaking it into smaller logical submodels. Or (if this is not possible) as a workaround you have to split mapping into two (or more) subexpressions. Also you need to have _ before all the parameter names after the break in the curried `create` function.
Example:

```swift
static func create
        (alreadyFollowed: Bool)
        (alreadyLived: Bool)
        (alreadyWanted: Bool)
        (langBarrier: Bool)
        (followedBy: Int)
        (index: Int)
        (lived: Int)
        (_ wanted: Int)
        (_ livedOutOfCriteria: Int)
        (_ storiesOutOfCriteria: Int)
        (_ stories: [Story])
        (_ nextStories: [Story])
        (_ previousStories: [Story]) -> StoryStat {...}
        
  static func decode(j: JSON) -> Decoded<StoryStat> {
        //Break the expression with more than 12 clauses into two parts: 
        let parseExpression = StoryStat.create
            <^> j <| "alreadyFollowed"
            <*> j <| "alreadyLived"
            <*> j <| "alreadyWanted"
            <*> j <| "langBarriere"
            <*> j <| "followedBy"
            <*> j <| "index"
            <*> j <| "lived"

         return parseExpression
            <*> j <| "wanted"
            <*> j <| "livedOutOfCriteria"
            <*> j <| "storiesOutOfCriteria"
            <*> j <|| "stories"
            <*> j <|| "nextStories"
            <*> j <|| "previousStories"
    }
  ```
