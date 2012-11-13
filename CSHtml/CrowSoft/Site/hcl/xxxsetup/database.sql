-- phpMyAdmin SQL Dump
-- version 2.6.1-rc1
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Generation Time: Oct 02, 2005 at 12:39 PM
-- Server version: 4.0.20
-- PHP Version: 4.3.11
-- 
-- Database: `hcl`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `activity`
-- 

CREATE TABLE `activity` (
  `id` int(255) NOT NULL auto_increment,
  `timestamp` int(255) default NULL,
  `operatorid` varchar(255) NOT NULL default '',
  `status` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `assigns`
-- 

CREATE TABLE `assigns` (
  `id` int(255) NOT NULL auto_increment,
  `departmentid` int(255) NOT NULL default '0',
  `operatorid` int(255) NOT NULL default '0',
  `poll` int(255) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `canned`
-- 

CREATE TABLE `canned` (
  `id` int(255) NOT NULL auto_increment,
  `departmentid` int(255) NOT NULL default '0',
  `operatorid` int(255) NOT NULL default '0',
  `subject` varchar(255) NOT NULL default '',
  `message` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `chat`
-- 

CREATE TABLE `chat` (
  `id` int(255) NOT NULL auto_increment,
  `chatid` int(255) NOT NULL default '0',
  `operatorid` int(255) NOT NULL default '0',
  `timestamp` int(255) default NULL,
  `message` text NOT NULL,
  `x` char(1) NOT NULL default '',
  `operator` int(1) NOT NULL default '0',
  `guest` int(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `cobrowse`
-- 

CREATE TABLE `cobrowse` (
  `id` int(255) NOT NULL auto_increment,
  `chatid` int(255) NOT NULL default '0',
  `page` text NOT NULL,
  `notified` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `coforms`
-- 

CREATE TABLE `coforms` (
  `id` int(255) NOT NULL auto_increment,
  `chatid` int(255) NOT NULL default '0',
  `receivedg` tinyint(1) NOT NULL default '0',
  `receivedo` tinyint(1) NOT NULL default '0',
  `type` text NOT NULL,
  `name` text NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `comarker`
-- 

CREATE TABLE `comarker` (
  `id` int(255) NOT NULL auto_increment,
  `chatid` int(255) NOT NULL default '0',
  `x` int(255) NOT NULL default '0',
  `y` int(255) NOT NULL default '0',
  `type` varchar(255) NOT NULL default '',
  `clear` tinyint(1) NOT NULL default '0',
  `receivedg` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `departments`
-- 

CREATE TABLE `departments` (
  `id` int(255) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `visible` int(1) NOT NULL default '1',
  `order` int(255) NOT NULL default '1',
  `email` varchar(255) NOT NULL default '',
  `email_host` varchar(255) NOT NULL default '',
  `email_port` int(5) NOT NULL default '25',
  `email_username` varchar(255) NOT NULL default '',
  `email_password` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `files`
-- 

CREATE TABLE `files` (
  `id` int(255) NOT NULL auto_increment,
  `chatid` int(255) default NULL,
  `file` blob NOT NULL,
  `type` varchar(255) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `size` varchar(255) NOT NULL default '0 kb',
  `status` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `footprints`
-- 

CREATE TABLE `footprints` (
  `id` int(255) NOT NULL auto_increment,
  `timestamp` int(255) default NULL,
  `chatid` int(255) NOT NULL default '0',
  `page` text NOT NULL,
  `cobrowse` tinyint(1) NOT NULL default '0',
  `current` int(1) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `chatid` (`chatid`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `hotpages`
-- 

CREATE TABLE `hotpages` (
  `id` int(255) NOT NULL auto_increment,
  `page` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `notes`
-- 

CREATE TABLE `notes` (
  `id` int(255) NOT NULL auto_increment,
  `timestamp` int(255) default '0',
  `operatorid` int(255) NOT NULL default '0',
  `subject` varchar(255) NOT NULL default '',
  `message` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `operators`
-- 

CREATE TABLE `operators` (
  `id` int(255) NOT NULL auto_increment,
  `username` varchar(255) NOT NULL default '',
  `password` varchar(255) NOT NULL default '',
  `firstname` varchar(255) NOT NULL default '',
  `lastname` varchar(255) NOT NULL default '',
  `email` varchar(255) NOT NULL default '',
  `level` int(1) NOT NULL default '0',
  `timestamp` int(255) default '0',
  `autosave` int(1) NOT NULL default '1',
  `showpic` int(1) NOT NULL default '0',
  `status` int(1) NOT NULL default '0',
  `sounds` int(1) NOT NULL default '1',
  `picture` blob NOT NULL,
  `accepts` int(255) NOT NULL default '0',
  `declines` int(255) NOT NULL default '0',
  `accepts_transfer` int(255) NOT NULL default '0',
  `declines_transfer` int(255) NOT NULL default '0',
  `accepts_opchat` int(255) NOT NULL default '0',
  `declines_opchat` int(255) NOT NULL default '0',
  `initiates` int(255) NOT NULL default '0',
  `onlinetime` int(255) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `polling`
-- 

CREATE TABLE `polling` (
  `id` int(255) NOT NULL auto_increment,
  `chatid` int(255) NOT NULL default '0',
  `assignid` int(255) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `reviews`
-- 

CREATE TABLE `reviews` (
  `id` int(255) NOT NULL auto_increment,
  `operatorid` int(255) NOT NULL default '0',
  `chatid` int(255) NOT NULL default '0',
  `transcriptid` int(255) NOT NULL default '0',
  `timestamp` int(255) NOT NULL default '0',
  `rating` int(1) NOT NULL default '0',
  `review` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `sessions`
-- 

CREATE TABLE `sessions` (
  `id` int(255) NOT NULL auto_increment,
  `chatid` int(255) NOT NULL default '0',
  `assignid` int(255) default NULL,
  `departmentid` int(255) default NULL,
  `operatorid` int(255) default NULL,
  `nick` varchar(255) default NULL,
  `alert` varchar(20) NOT NULL default '',
  `timeo` int(255) NOT NULL default '0',
  `timeg` int(255) NOT NULL default '0',
  `typeo` int(255) NOT NULL default '0',
  `typeg` int(255) NOT NULL default '0',
  `transfer` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `stats_referrers`
-- 

CREATE TABLE `stats_referrers` (
  `id` int(255) NOT NULL auto_increment,
  `chatid` int(255) NOT NULL default '0',
  `timestamp` int(255) NOT NULL default '0',
  `url` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `stats_visitors`
-- 

CREATE TABLE `stats_visitors` (
  `id` int(255) NOT NULL auto_increment,
  `timestamp` int(255) NOT NULL default '0',
  `visits` int(255) NOT NULL default '0',
  `hits` int(255) NOT NULL default '0',
  `requests` int(255) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `system`
-- 

CREATE TABLE `system` (
  `id` int(255) NOT NULL auto_increment,
  `timestamp` int(255) default NULL,
  `operatorid` int(255) NOT NULL default '0',
  `chatid` int(255) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `traffic`
-- 

CREATE TABLE `traffic` (
  `id` int(255) NOT NULL auto_increment,
  `timestamp` int(255) default NULL,
  `ip` varchar(255) NOT NULL default '',
  `useragent` text default NULL,
  `hostname` varchar(255) NOT NULL default '',
  `referrer` text default NULL,
  `requests` int(255) NOT NULL default '0',
  `visits` int(255) NOT NULL default '1',
  `start` int(255) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `transcripts`
-- 

CREATE TABLE `transcripts` (
  `id` int(255) NOT NULL auto_increment,
  `timestamp` int(255) default NULL,
  `chatid` int(255) NOT NULL default '0',
  `operatorid` int(255) NOT NULL default '0',
  `departmentid` int(255) NOT NULL default '0',
  `guest` varchar(255) NOT NULL default '',
  `hostname` varchar(255) NOT NULL default '',
  `transcript` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;
        
        