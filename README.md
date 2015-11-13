
# 简介

此案例实现的用户注册、用户登录、发贴、显示所有帖子资料以及对帖子进行点赞的功能 。

# 表结构

使用了三个表，分别如下

_User：用户表

| 列名        | 类型   | 含义 |
|:------------|:-------|:---- |
| username    | string | 账号 |
| password    | string | 密码 |


Post：帖子表

| 列名        | 类型          | 含义 |
| ------------|:--------------|:-----|
| title       | string        | 标题 |
| content     | string        | 内容 |
| author      |Pointer(_User) | 作者 |


Likes：关联表，记录了每一条点赞记录的点赞人及对应的帖子。

| 列名        | 类型          | 含义  |
| ------------|:--------------|:------|
| user        | Pointer(_User)| 点赞人|
| post        | Pointer(Post) | 帖子  |


# 云端代码

使用云端代码来获取所有帖子以及其所有点赞人的名字（可根据需求修改代码以返回需要的点赞人的其它信息）。

```
方法名:loadPost

function onRequest(request, response, modules) {
    var db = modules.oData;
    db.find({
        "table":"Post"   
    },function(err,data){
        //获取所有帖子
        var postJsonArray =  JSON.parse(data).results;

        var rel = modules.oRelation;
        rel.query({
            "table":"Likes",
            "include":"user,post" 
        },function(err,data){
            //获取所有点赞记录
            var likesJsonArray = JSON.parse(data).results;

            //遍历每个帖子
            for (var i in postJsonArray) {
                
                var postObjectId = postJsonArray[i].objectId;
                
                //存储想要得到的用户信息
                var likePostUserArray = new Array();
                
                //遍历点赞记录，将属于该帖子的点赞记录找出
                for (var j in likesJsonArray) {
                    
                    var likesPostId = likesJsonArray[j].post.objectId;
                    if (postObjectId == likesPostId){
                        //存储点赞人名字，可根据需求存储更多的信息
                        likePostUserArray.push(likesJsonArray[j].user.username);
                    }
                }
                
                postJsonArray[i]["likes"] = likePostUserArray;
            }
            
            response.send(postJsonArray);
            
        });
    });
}                                                                                                                                                 
```