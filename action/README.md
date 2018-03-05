# 实战 <br/>
1.实现广告广告词功能<br/>
CREATE TABLE test_ad(<br/>
    ad_id BIGINT,<br/>
    content VARCHAR(4000)<br/>
) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment '测试广告表';<br/>
逻辑：通过nginx读取redis中的广告词，如果不存在，则从mysql中读取并且放入到redis中。<br/>
