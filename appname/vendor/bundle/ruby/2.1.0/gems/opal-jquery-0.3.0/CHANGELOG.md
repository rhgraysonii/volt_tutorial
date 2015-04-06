## EDGE

## 0.3.0 2015-02-03

*   Move all files under `opal/jquery` require namespace, rather than
    current `opal-jquery` require paths.

*   Add `Browser::Window` class, and make `::Window` an instance of it.

*   Make `Document` include `Browser::DocumentMethods` which is a simple
    module to define custom methods for `Document`.

*   Cleanup HTTP implementation.

*   `Element#[]` and `Element#attr` now return `nil` for empty attributes,
    instead of returning an empty string.

*   Add `HTTP.setup` and `HTTP.setup=` to access `$.ajaxSetup`

*   Add PATCH and HEAD support to `HTTP`

*   Let `Element` accept previously defined `JQUERY_CLASS` and `JQUERY_SELECTOR`
    for environments such as node-webkit where `$` can't be found in the global object.

*   Add Promise support to `HTTP` get/post/put/delete methods. Also remove
    `HTTP#callback` and `#errback` methods.

## 0.2.0 2014-03-12

*   Add `Document.body` and `Document.head` shortcut to element instances.

*   Add `Event` methods: `prevented?`, `prevent`, `stopped?` and `stop` to
    replace longer javascript names.

*   Add `LocalStorage` implementation.

*   Fix `Element#data()` to return `nil` for an undefined data attribute
    instead of null.

*   Expose `#detach` method on `Element`.

## 0.1.2 2013-12-01

*   Support setting html content through `Element#html()`.

*   Add `Element` methods: `#get`, `#attr` and `#prop` by aliasing them to
    jquery implementations.

## 0.1.1 2013-11-03

*   Require `native` from stdlib for `HTTP` to use.

## 0.1.0 2013-11-03

*   Add `Window` and `$window` alias.

*   Support `Zepto` as well as `jQuery`.

*   `Event` is now a wrapper around native event from dom listeners.

## 0.0.9 2013-06-15

*   Revert earlier commit, and use `$document` as reference to jquery
    wrapped `document`.

*   Introduce Element.document as wrapped document element

*   Depreceate $document.title and $document.title=.

## 0.0.8 2013-05-02

*   Depreceate Document in favor of $document global.

*   Add HTTP.delete() for creating DELETE request.

## 0.0.7 2013-02-20

*   Add Element#method\_missing which forwards missing calls to try and call
    method as a native jquery function/plugin.

*   Depreceate Document finder methods (Document.find, Document[]). The finder
    methods on Element now replace them. Updated specs to suit.
