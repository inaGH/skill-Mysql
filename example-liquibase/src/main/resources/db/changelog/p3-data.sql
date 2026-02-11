--liquibase formatted sql

--changeset other.dev:data-1 labels:example-label context:example-context
--comment: example comment
INSERT INTO `test`.`company` (`id`, `name`, `address1`, `address2`, `city`) VALUES (1, '企业', '滨江', '余杭', '杭州')
--rollback delete from `test`.`company` where id=1;