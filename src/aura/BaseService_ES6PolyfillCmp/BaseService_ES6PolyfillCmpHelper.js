({
    polyfillAssignMethod : function(){
        if(typeof Object.assign != 'function'){
            Object.defineProperty(Object, 'assign', {
                value : function(target){
                    'use strict';

                    if(target == null){
                        throw new TypeError('Cannot convert undefined or null to object');
                    }

                    var to = Object(target);

                    for(var index = 1; index < arguments.length; index++){
                        var nextSource = arguments[i];

                        if (nextSource != null){
                            //遍历全部可枚举属性
                            for (var nextKey in nextSource){
                                // Avoid bugs when hasOwnProperty is shadowed，确保是自己的属性而不是继承来的
                                if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)){
                                    to[nextKey] = nextSource[nextKey];
                                }
                            }
                        }
                    }

                    return to;
                },
                enumerable : false,
                writable : true,
                configurable : true
            })
        }
    }
})