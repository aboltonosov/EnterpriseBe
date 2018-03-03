﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Открывает в качестве расшифровки переданной ячейки предварительно подготовленный вариант отчета
// Параметры:
//	ИДОтчета - Строка - идентификатор отчета (совпадает с именем объекта метаданных).
// 	ИДРедакцииОтчета - Строка - идентификатор редакции формы отчета (совпадает с именем формы объекта метаданных).
//  ИДИменПоказателей - Массив - массив идентификаторов имен показателей, по которым формируется расшифровка.
//  ПараметрыОтчета - Структура - структура параметров отчета, необходимых для формирования расшифровки.
// 
Процедура ОткрытьРасшифровкуРегламентированногоОтчета(ИДОтчета, ИДРедакцииОтчета, ИДИменПоказателей, ПараметрыОтчета) Экспорт
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьРасшифровкуРегламентированногоОтчета(ИДОтчета, ИДРедакцииОтчета, ИДИменПоказателей, ПараметрыОтчета);
КонецПроцедуры

// Процедура реализует печать объектов, отображаемых на закладке Отчеты и Уведомления формы Отчетность
// Параметры - (см. РегламентированнаяОтчетностьКлиентПереопределяемый.Печать) 
//	 
Процедура ПечатьДокументаОтчетности(Ссылка, ИмяМакетаДляПечати, СтандартнаяОбработка) Экспорт
	ЗарплатаКадрыРасширенныйКлиент.ПечатьДокументаОтчетности(Ссылка, ИмяМакетаДляПечати, СтандартнаяОбработка);	
КонецПроцедуры	

// Процедура реализует печать объектов, отображаемых на закладке Отчеты и Уведомления формы Отчетность
// Параметры - (см. РегламентированнаяОтчетностьКлиентПереопределяемый.Выгрузить) 
//	 
Процедура ВыгрузитьДокументОтчетности(Ссылка) Экспорт
	ЗарплатаКадрыРасширенныйКлиент.ВыгрузитьДокументОтчетности(Ссылка);	
КонецПроцедуры	

// Процедура реализует печать объектов, отображаемых на закладке Отчеты и Уведомления формы Отчетность
// Параметры - (см. РегламентированнаяОтчетностьКлиентПереопределяемый.СоздатьНовыйОбъект) 
//	 
Процедура СоздатьНовыйДокументОтчетности(Организация, Тип, СтандартнаяОбработка) Экспорт
	ЗарплатаКадрыРасширенныйКлиент.СоздатьНовыйДокументОтчетности(Организация, Тип, СтандартнаяОбработка);	
КонецПроцедуры	

// Открывает форму ОтветственныхЛиц
// 
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, форму ответственныхлиц которой нужно открыть
//
Процедура ОткрытьФормуСведенийОтветственныхЛиц(Организация) Экспорт
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуСведенийОтветственныхЛиц(Организация);
КонецПроцедуры