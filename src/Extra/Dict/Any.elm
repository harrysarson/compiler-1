module Extra.Dict.Any exposing (combine, find)

import Dict.Any exposing (AnyDict)


{-| Adapted from `elm-community/dict-extra` for the Dict.Any type.

Find the first key/value pair that matches a predicate.

    Dict.Any.fromList [ ( 9, "Jill" ), ( 7, "Jill" ) ]
        |> find (\_ value -> value == "Jill")
    --> Just ( 7, "Jill" )

    Dict.Any.fromList [ ( 9, "Jill" ), ( 7, "Jill" ) ]
        |> find (\key _ -> key == 5)
    --> Nothing

-}
find : (k -> v -> Bool) -> AnyDict comparable k v -> Maybe ( k, v )
find predicate dict =
    Dict.Any.foldl
        (\k v acc ->
            case acc of
                Just _ ->
                    acc

                Nothing ->
                    if predicate k v then
                        Just ( k, v )

                    else
                        Nothing
        )
        Nothing
        dict


{-| Similar to Result.Extra.combine which works for Lists.
-}
combine : (k -> comparable) -> AnyDict comparable k (Result err v) -> Result err (AnyDict comparable k v)
combine toKey dictOfResults =
    dictOfResults
        |> Dict.Any.foldr
            {- Is this readable enough? We're creating a new dict with the same
               key but the contents of the Results, not the Results themselves.
            -}
            (Result.map2 << Dict.Any.insert)
            (Ok (Dict.Any.empty toKey))
