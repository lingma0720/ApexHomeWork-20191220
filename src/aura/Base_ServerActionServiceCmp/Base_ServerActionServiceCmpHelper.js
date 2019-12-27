({
	enqueueAction : function(component, action) {
        var helper = this;

        if(typeof helper.Promise === 'undefined'){
            if(window.Promise){
                helper.Promise = window.Promise;
            }else{
                helper.Promise = helper.injectPromise();
            }
        }

        return new helper.Promise(function(resolve, reject){
            if($A.util.isEmpty(action)) resolve();

        	action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === 'SUCCESS') {
	                resolve(response.getReturnValue());
	            }
	            else if (state === 'ERROR') {
	                reject(helper.getRestError(response));
	            }
	        });

	        $A.enqueueAction(action);
        });
    },
	getRestError : function(response) {
        var errors = response.getError();
        if ($A.util.isEmpty(errors) || errors.length == 0) {
            return null;
        }

        if (errors[0].message) {
            return errors[0].message;
        } else if (errors[0].pageErrors.length>0) {
            if (errors[0].pageErrors[0].message)
                return JSON.stringify(errors[0].pageErrors[0].message);

            return JSON.stringify(errors[0].pageErrors[0]);
        } else if (errors[0].duplicateResults.length>0) {
            return JSON.stringify(errors[0].duplicateResults[0]);
        } else if (errors[0].fieldErrors) {
            var fieldErrorMsg = '';
            for(var key in errors[0].fieldErrors){
                fieldErrorMsg = errors[0].fieldErrors[key][0].message;
            }
            return fieldErrorMsg;
        } else {
            return null;
        }


    },
    injectPromise : function(){
        function Promise(executor){ //executor 是一个执行器（同步或异步函数）
            var _this = this;

            _this.status = 'pending';
            _this.value = undefined;
            _this.reason = undefined;
            _this.onResolvedCallbacks = []; // 存放then成功的回调
            _this.onRejectedCallbacks = []; // 存放then失败的回调


            function resolve(value) { // 内置一个resolve方法，接收成功状态数据
                // 只有pending可以转为其他状态，所以这里要判断一下
                if (_this.status === 'pending') {
                    _this.status = 'resolved' // 当调用resolve时要将状态改为成功态
                    _this.value = value // 保存成功时传进来的数据
                }
            }
            function reject(reason) { // 内置一个reject方法，失败状态时接收原因
                if (_this.status === 'pending') { // 和resolve同理
                    _this.status = 'rejected' // 转为失败态
                    _this.reason = reason // 保存失败原因
                }
            }

            executor(resolve, reject) // 执行执行器函数，并将两个方法传入

        }

         Promise.prototype.then = function (onFulfilled, onRjected) {
            //成功和失败默认不传给一个函数，解决了问题8
            onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : function (value) {
                return value;
            }
            onRjected = typeof onRjected === 'function' ? onRjected : function (err) {
                throw err;
            }
            var _this = this;
            var promise2; //返回的promise
            if (_this.status === 'resolved') {
                promise2 = new Promise(function (resolve, reject) {
                    // 当成功或者失败执行时有异常那么返回的promise应该处于失败状态
                    setTimeout(function () {// 根据规范让那俩家伙异步执行
                        try {
                            var x = onFulfilled(_this.value);//这里解释过了
                            // 写一个方法统一处理问题1-7
                            resolvePromise(promise2, x, resolve, reject);
                        } catch (e) {
                            reject(e);
                        }
                    })
                })
            }
            if (_this.status === 'rejected') {
                promise2 = new Promise(function (resolve, reject) {
                    setTimeout(function () {
                        try {
                            var x = onRjected(_this.reason);
                            resolvePromise(promise2, x, resolve, reject);
                        } catch (e) {
                            reject(e);
                        }
                    })
                })
            }
            if (_this.status === 'pending') {
                promise2 = new Promise(function (resolve, reject) {
                    _this.onResolvedCallbacks.push(function () {
                        setTimeout(function () {
                            try {
                                var x = onFulfilled(_this.value);
                                resolvePromise(promise2, x, resolve, reject);
                            } catch (e) {
                                reject(e)
                            }
                        })
                    });
                    _this.onRejectedCallbacks.push(function () {
                        setTimeout(function () {
                            try {
                                var x = onRjected(_this.reason);
                                resolvePromise(promise2, x, resolve, reject);
                            } catch (e) {
                                reject(e);
                            }
                        })
                    });
                })
            }
            return promise2;
        }

        function resolvePromise(promise2, x, resolve, reject) {
            // 接受四个参数，新Promise、返回值，成功和失败的回调
            // 有可能这里返回的x是别人的promise
            // 尽可能允许其他乱写
            if (promise2 === x) { //这里应该报一个类型错误，来解决问题4
                return reject(new TypeError('循环引用了'))
            }
            // 看x是不是一个promise,promise应该是一个对象
            var called; // 表示是否调用过成功或者失败，用来解决问题7
            //下面判断上一次then返回的是普通值还是函数，来解决问题1、2
            if (x !== null && (typeof x === 'object' || typeof x === 'function')) {
                // 可能是promise {},看这个对象中是否有then方法，如果有then我就认为他是promise了
                try {
                    var then = x.then;// 保存一下x的then方法
                    if (typeof then === 'function') {
                        // 成功
                        //这里的y也是官方规范，如果还是promise，可以当下一次的x使用
                        //用call方法修改指针为x，否则this指向window
                        then.call(x, function (y) {
                            if (called) return //如果调用过就return掉
                            called = true
                            // y可能还是一个promise，在去解析直到返回的是一个普通值
                            resolvePromise(promise2, y, resolve, reject)//递归调用，解决了问题6
                        }, function (err) { //失败
                            if (called) return
                            called = true
                            reject(err);
                        })
                    } else {
                        resolve(x)
                    }
                } catch (e) {
                    if (called) return
                    called = true;
                    reject(e);
                }
            } else { // 说明是一个普通值1
                resolve(x); // 表示成功了
            }
        }

        Promise.deferred = function () {
            var dfd = {};
            dfd.promise = new Promise(function (resolve, reject) {
                dfd.resolve = resolve;
                dfd.reject = reject;
            });
            return dfd
        }

        // 捕获错误的方法，在原型上有catch方法，返回一个没有resolve的then结果即可
        Promise.prototype.catch = function (callback) {
            return this.then(null, callback)
        }
        // 解析全部方法，接收一个Promise数组promises,返回新的Promise，遍历数组，都完成再resolve
        Promise.all = function (promises) {
            //promises是一个promise的数组
            return new Promise(function (resolve, reject) {
                var arr = []; //arr是最终返回值的结果
                var i = 0; // 表示成功了多少次
                function processData(index, y) {
                    arr[index] = y;
                    if (++i === promises.length) {
                        resolve(arr);
                    }
                }
                for (var i = 0; i < promises.length; i++) {
                    promises[i].then(function (y) {
                        processData(i, y)
                    }, reject)
                }
            })
        }
        // 只要有一个promise成功了 就算成功。如果第一个失败了就失败了
        Promise.race = function (promises) {
            return new Promise(function (resolve, reject) {
                for (var i = 0; i < promises.length; i++) {
                    promises[i].then(resolve,reject)
                }
            })
        }
        // 生成一个成功的promise
        Promise.resolve = function(value){
            return new Promise(function(resolve,reject){
                resolve(value);
            })
        }
        // 生成一个失败的promise
        Promise.reject = function(reason){
            return new Promise(function(resolve,reject){
                reject(reason);
            })
        }

        return Promise;
    }
})