/**
 * @file 常用方法
 * @author ielgnaw(wuji0223@gmail.com)
 */

/**
 * 数组去重
 *
 * @param {Array} arr 需要去掉重复项的数组
 *
 * @return {Array} 结果数组
 */
exports.arrUnique = function (arr) {
    var ret = [];
    var obj = {};
    for (var i = 0, len = arr.length; i < len; i++) {
        if (!obj[arr[i]]) {
            ret.push(arr[i]);
            obj[arr[i]] = 1;
        }
    }
    return ret;
};

/**
 * 根据条件删除数组里的第一个满足条件的项，只会删除第一个，改变的是原数组
 *
 * @param {Array} list 待删除的数组
 * @param {Function} callback 条件函数，返回 true 就执行
 */
exports.removeArrByCondition = function (list, callback) {
    var candidateIndex = -1;
    var tmp;
    for (var i = 0, len = list.length; i < len; i++) {
        tmp = list[i];
        if (callback(tmp)) {
            candidateIndex = i;
            break;
        }
    }

    if (candidateIndex !== -1) {
        list.splice(candidateIndex, 1);
    }
};
