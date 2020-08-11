# Vogue Runway API

## Queries Introduction

The API works by requesting specific parts of data from a particular source to shape a data tree. This data tree can be customized to provide as much, or as little, data as needed.

The examples below are all taken directly from the app so in theory should contain all of the possible data types for a particular source. Although you can shape requests to your liking it is highly recommended that you copy the requests below to "blend in" with the other users of the app.

### Technical Details

- **All keys returned and listed below should be considered as optionals**, sometimes they will be `null`.
- All `GET` queries are a compressed string with the HTML "percent encoding", e.g `{` becomes `%20`.
- Should contain a `Vogue%20Runway/7` user agent.
- The host is always `graphql.vogue.com` and the directory is always `/graphql`.
- The `GET` queries use a modified form of JSON.
- The returns use pure JSON.

### Fragments

Within requests custom "fragments" can be used to quickly generate requests. A fragment is similar to a class in programming and always subclasses an existing fragment that exists.

Like a normal request, a fragment contains specific objects and data types to include in a request. They are used to make requests smaller in size.

## List houses

```
GET /graphql?query={query} HTTP/1.1
Host: graphql.vogue.com
Content-Type: application/json
Accept: */*
User-Agent: Vogue%20Runway/7 CFNetwork/978.0.7 Darwin/18.5.0
Accept-Language: en-gb
Accept-Encoding: gzip, deflate
Connection: close
```

### Query

#### Raw Decoded
```
query { allBrands { Brand { name slug } }}
```

#### Formatted
```
query {
  allBrands {
    Brand { name slug }
  }
}
```

### Return

All possible houses are returned, at time of writing this is more than 1600.

#### Root structure

The data is wrapped in the root key `data (object)` and the key inside, `allContent (object)`. No other data is found outside of `allContent (object)`. Houses are found inside the array `Brand (array)`.

```
{
  "data": {
    "allBrands": {
      "Brand": []
    }
  }
}
```

#### Brand Object

Inside of `Brand (array)` is an array of "brand" objects that are all identical in nature.

 Key | Description | Type |
|-|-|-|
| name | Name of the house | String |
| slug | Slug (identifier) of the house | String |



## List collections

```
GET /graphql?query={query} HTTP/1.1
Host: graphql.vogue.com
Content-Type: application/json
Accept: */*
User-Agent: Vogue%20Runway/7 CFNetwork/978.0.7 Darwin/18.5.0
Accept-Language: en-gb
Accept-Encoding: gzip, deflate
Connection: close
```

### Query

First get the slug of a fashion house and then place it within `allContent<filter.brand.slug>`, the example below "chanel" is used.

#### Raw Decoded
```
query { allContent(type: ["FashionShowV2"], first: 25, filter: { brand: { slug: "chanel" } }) { Content { id GMTPubDate url title slug _cursor_ ... on FashionShowV2 { instantShow brand { name slug } season { name slug year } photosTout { ... on Image { url } } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } } }
```

#### Formatted
```
query {
    allContent(
      type: ["FashionShowV2"],
      first: 18,
      filter: {
        brand: {
          slug: "chanel"
        }
      }
    )
    {
      Content {
        id GMTPubDate url title slug _cursor_ ... on FashionShowV2 {
          instantShow brand { name slug } season { name slug year } photosTout { ... on Image { url } } 
        }
    }
    pageInfo {
      hasNextPage hasPreviousPage startCursor endCursor
    } 
  }
}
```

### Return

A JSON tree is returned containing 25 collections (based on the requested amount) alongside metadata containing info about if a next/previous exists and the start/ending page cursor.

#### Root structure

The data is wrapped in the root key `data (object)` and the key inside, `allContent (object)`. No other data is found outside of `allContent (object)`. Collections are found inside the array `Content (array)` and the page info is found inside the object `pageInfo (object)`.

```
{
  "data": {
    "allContent": {
      "Content": [],
      "pageInfo": {}
    }
  }
}
```

#### Collections

Inside of `Content (array)` is an array of collection objects that are all identical in nature. An example object:

 Key | Description | Type |
|-|-|-|
| id | ID of the collection | String |
| GMTPubData | ISO 8601 publish date of the vogue.com article | String |
| url | URL to the collection | String |
| title | Title of the collection | String |
| slug | Slug (identifier) of the collection | String |
| \_cursor\_ | Unknown, some internal internal API id | String |
| instantShow | Unknown | Bool |
| brand | `name (String)`: Name of the house, `slug (String)`: Slug (identifier) of the house | Object |
| season | `name (String)`: Title of the season, `slug (String)`: Slug (identifier) of the season, `year (Int)`: Year of the season | Object |
| photosTout | `url (String)`: thumbnail for the collection | Object | 

#### Page info

The `pageInfo (object)` object contains details needed for paging. An example object:

 Key | Description | Type |
|-|-|-|
| hasNextPage | If a page lies after this one | Bool |
| hasPreviewPage | If a page lies before this one | Bool |
| startCursor | Unknown, some form of ID | String |
| endCursor | Unknown, some form of ID | String |

### Collection

```
GET /graphql?query={query} HTTP/1.1
Host: graphql.vogue.com
Content-Type: application/json
Accept: */*
User-Agent: Vogue%20Runway/7 CFNetwork/978.0.7 Darwin/18.5.0
Accept-Language: en-gb
Accept-Encoding: gzip, deflate
Connection: close
```

### Query

#### Raw Decoded
```
 { fashionShowV2(slug: "fall-2019-ready-to-wear/chanel") { GMTPubDate url title slug id instantShow city { name } brand { name slug } season { name slug year } photosTout { ... on Image { url } } review { pubDate body contributor { author { name photosTout { ... on Image { url } } } } } galleries { collection { ... GalleryFragment } atmosphere { ... GalleryFragment } beauty { ... GalleryFragment } detail { ... GalleryFragment } frontRow { ... GalleryFragment } } video { url cneId title } } } fragment GalleryFragment on FashionShowGallery { title meta { ...metaFields } slidesV2 { ... on GallerySlidesConnection { slide { ... on Slide { id credit photosTout { ...imageFields } } ... on CollectionSlide { id type credit title photosTout { ...imageFields } }  __typename } } } } fragment imageFields on Image { id url caption credit width height } fragment metaFields on Meta { facebook { title description } twitter { title description } }
 ```

#### Formatted

First get the slug of a collection and then place it within `fashionShowV2<slug>`, in the example below "fall-2019-ready-to-wear/chanel" is used.

```
 {
  fashionShowV2(
    slug: "fall-2019-ready-to-wear/chanel"
  )
  {
    GMTPubDate url title slug id instantShow city { name } brand { name slug } season { name slug year } photosTout { ... on Image { url } }
    review {
      pubDate body contributor {
        author {
          name photosTout {
            ... on Image { url }
          }
        }
      }
    }
    galleries {
      collection {
        ... GalleryFragment
      }
      atmosphere {
        ... GalleryFragment
      }
      beauty
      {
        ... GalleryFragment
      }
      detail {
        ... GalleryFragment
      }
      frontRow {
        ... GalleryFragment
      }
    }
    video { url cneId title }
  }
}
fragment GalleryFragment on FashionShowGallery {
  title meta { ...metaFields } slidesV2 {
    ... on GallerySlidesConnection {
      slide {
        ... on Slide {
          id credit photosTout { ...imageFields }
        }
        ... on CollectionSlide {
          id type credit title photosTout { ...imageFields }
        }  __typename
      } 
    }
  }
}
fragment imageFields on Image {
  id url caption credit width height
}
fragment metaFields on Meta {
  facebook { title description } twitter { title description }
}
 ```

### Return

A lot of data is returned in this request, most noteably: metadata you would expect to find (city, house, id, slug, etc...), galleries containing photos (collection, atmosphere, beauty, detail, front row) and a review of the collection (including review metadata, e.g. author).

The gallery can contain as little as 10 photos all the way to 250 and more in some rare cases, this is of course based on the size of the collection. Expect the `beauty` and `detail` galleries to the be the largest in size as they may contain multiple photos for one look.

#### Root structure

The data is wrapped in the root key `data (object)` and the key inside, `fashionShowV2 (object)`. No other data is found outside of `fashionShowV2 (object)`.

```
{
  "data": {
    "fashionShowV2": { }
  }
}
```

This is the data within `fashionShowV2 (object)`:

| Key | Description | Type |
|-|-|-|
| GMTPubDate | ISO 8601 publish date of the vogue.com article | String |
| url | URL to the collection | String |
| title | Title of the collection | String |
| slug | Slug (identifier) of the collection | String |
| id | Unique ID of the collection | String |
| instantShow | Unknown | Bool |
| city | `name (String)`: this key contains the city the show was held in | Object |
| brand | `name (String)`: name of the brand, `slug (String)`: Slug (identifier) of the brand | Object |
| season | `name (String)`: title of the season, `slug (String)`: Slug (identifier) of the season, `year (Int)`: Year of the collection | Object |
| photosTout | `url (String)`: thumbnail for the collection | Object |
| review | `Review` object can be found below | Object (`Review` object) |
| galleries | `Galleries` object can be found below | Object (`galleries` object) |

#### Galleries Object

A galleries object will return the galleries requested in the query. However in the likely case that a gallery is not present for a particular collection then the gallery object will have a value of `null`.

The request above will return an object with the following keys and are all of the known gallery types:

- `collection (Object)`
- `atmosphere (Object)`
- `beauty (Object)`
- `detail (Object)`
- `frontRow (Object)`

A `video` object is also known however is not understood at this moment.

#### Gallery Object

A gallery object contains some small metadata and all of the slides (photos).

| Key | Description | Type |
|-|-|-|
| title | Title of the gallery | String |
| meta | Metadata for Twitter and Facebook, currently undocumented | Object |
| slidesV2 | `slide (Array)`: A slide object (documentation below) containing the URL and metadata of a photo | Object |

#### Slide Object

A slide object contains the photo object and metadata for a slide.

| Key | Description | Type |
|-|-|-|
| id | ID of a slide | String |
| type | Type of a slide, only `look` is currently known | String |
| credit | Title of a slide, mostly `null` | String |
| __typename | Internal API type name, currently undocumented | String |
| photosTout | Photo object (documented below) | Object |

#### Photo Object

A photo object contains the URL of a photo alongside its metadata.

| Key | Description | Type |
|-|-|-|
| id | ID of a photo | String |
| url | URL of the photo | String |
| caption | Caption of the photo, mostly `null` | String |
| credit | Credit for a photo | String |
| width | Width of the photo | Int |
| height | Height of the photo | Int |