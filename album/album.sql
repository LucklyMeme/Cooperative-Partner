/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 50546
Source Host           : localhost:3306
Source Database       : album

Target Server Type    : MYSQL
Target Server Version : 50546
File Encoding         : 65001

Date: 2017-11-19 15:11:20
*/

SET FOREIGN_KEY_CHECKS=0;


DROP DATABASE IF EXISTS `album`;
CREATE DATABASE `album`;
USE album;


-- ----------------------------
-- Table structure for album_dir
-- ----------------------------
DROP TABLE IF EXISTS `album_dir`;
CREATE TABLE `album_dir` (
  `dir` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of album_dir
-- ----------------------------
INSERT INTO `album_dir` VALUES ('aaa');
INSERT INTO `album_dir` VALUES ('vvv');
INSERT INTO `album_dir` VALUES ('vvvb');

-- ----------------------------
-- Table structure for album_file
-- ----------------------------
DROP TABLE IF EXISTS `album_file`;
CREATE TABLE `album_file` (
  `file` varchar(255) NOT NULL,
  `dir` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


