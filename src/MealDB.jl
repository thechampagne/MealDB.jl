# Copyright 2022 XXIV
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
module MealDB

using HTTP
using JSON

export search, searchbyletter, searchbyid, filter_bycategory
export mealcategories, filter_byingredient, filter_byarea, random
export categoriesfilter, ingredientsfilter, areafilter

struct MealDBException <: Exception
    msg
end

function _getrequest(endpoint::String)
    try
        request = HTTP.request("GET", "https://themealdb.com/api/json/v1/1/$endpoint")
        response = String(request.body)
        return response
    catch ex
        if isa(ex, HTTP.ExceptionRequest.StatusError)
            return String(ex.response.body)
        else
            rethrow(ex)
        end
    end
end

"""
Search meal by name

 * `s` meal name

"""
function search(s::String)
    try
        response = _getrequest("search.php?s=$(HTTP.URIs.escapeuri(s))")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["meals"]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
Search meals by first letter

* `c` meal letter
 
"""
function searchbyletter(c::Char)
    try
        response = _getrequest("search.php?f=$c")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["meals"]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
Search meal details by id

* `i` meal id
 
"""
function searchbyid(i::Int)
    try
        response = _getrequest("lookup.php?i=$i")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["meals"][1]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
Search a random meal

"""
function random()
    try
        response = _getrequest("random.php")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["meals"][1]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
Meal Categories

"""
function mealcategories()
    try
        response = _getrequest("categories.php")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["categories"] == nothing || length(json["categories"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["categories"]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
Filter by ingredient

* `s` ingredient name

"""
function filter_byingredient(s::String)
    try
        response = _getrequest("filter.php?i=$(HTTP.URIs.escapeuri(s))")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["meals"]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
Filter by area

* `s` area name

"""
function filter_byarea(s::String)
    try
        response = _getrequest("filter.php?a=$(HTTP.URIs.escapeuri(s))")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["meals"]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
Filter by Category

* `s` category name

"""
function filter_bycategory(s::String)
    try
        response = _getrequest("filter.php?c=$(HTTP.URIs.escapeuri(s))")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["meals"]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
List the categories filter

"""
function categoriesfilter()
    try
        response = _getrequest("list.php?c=list")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        array = String[]
        for i in json["meals"]
            push!(array, i["strCategory"])
        end
        return array
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
List the ingredients filter

"""
function ingredientsfilter()
    try
        response = _getrequest("list.php?i=list")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        return json["meals"]
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

"""
List the area filter

"""
function areafilter()
    try
        response = _getrequest("list.php?a=list")
        if length(response) == 0
            throw(MealDBException("Something went wrong: Empty response"))
        end
        json = JSON.parse(response)
        if json["meals"] == nothing || length(json["meals"]) == 0
           throw(MealDBException("Something went wrong: Empty response"))
        end
        array = String[]
        for i in json["meals"]
            push!(array, i["strArea"])
        end
        return array
    catch ex
        if isa(ex, MealDBException)
            rethrow(ex)
        else
            throw(MealDBException(sprint(showerror, ex)))
        end
    end
end

end # MealDB