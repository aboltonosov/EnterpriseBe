﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
		
	Если НаДату > '20110101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияФСГС;
	КонецЕсли;
		
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв3";
	НоваяФорма.ОписаниеОтчета     = "Введена Приказом Департамента труда и занятости населения города Москвы № 277 от 01.10.2009.";
	НоваяФорма.РедакцияФормы	  = "от 01.10.2009 № 277.";
	НоваяФорма.ДатаНачалоДействия = '20090701'; // Введена в действие с отчета за II квартал 2005 года
	НоваяФорма.ДатаКонецДействия  = '20111231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
	НоваяФорма.ОписаниеОтчета     = "Введена приказом Департамента труда и занятости населения города Москвы от 01.03.2012 № 119.";
	НоваяФорма.РедакцияФормы	  = "от 01.03.2012 № 119.";
	НоваяФорма.ДатаНачалоДействия = '20120101'; // Введена в действие с отчета за I квартал 2012 года
	НоваяФорма.ДатаКонецДействия  = '20130630';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв3";
	НоваяФорма.ОписаниеОтчета     = "Введена приказом Департамента труда и занятости населения города Москвы от 29.08.2013 № 449.";
	НоваяФорма.РедакцияФормы	  = "от 29.08.2013 № 449.";
	НоваяФорма.ДатаНачалоДействия = '20130701'; // Введена в действие с отчета за III квартал 2013 года
	НоваяФорма.ДатаКонецДействия  = '20150630';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв2";
	НоваяФорма.ОписаниеОтчета     = "Введена приказом Департамента труда и занятости населения города Москвы от 20.07.2015 № 385.";
	НоваяФорма.РедакцияФормы	  = "от 20.07.2015 № 385.";
	НоваяФорма.ДатаНачалоДействия = '20150701'; // Введена в действие с отчета за III квартал 2015 года
	НоваяФорма.ДатаКонецДействия  = '20161231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приказ Департамента труда и социальной защиты населения города Москвы от 01.02.2017г. №72.";
	НоваяФорма.РедакцияФормы	  = "от 01.02.2017 № 72.";
	НоваяФорма.ДатаНачалоДействия = '20170101'; // Введена в действие с отчета за I квартал 2017 года
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));


	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20091001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1-квот", '20091001', "277",	"ФормаОтчета2009Кв3");
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1-квот", '20120301', "119",	"ФормаОтчета2012Кв1");
	Форма20130701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1-квот", '20130829', "449",	"ФормаОтчета2013Кв3");
	Форма20130701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1-квот", '20150720', "385",	"ФормаОтчета2015Кв2");
	Форма20130701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1-квот", '20170201', "72",	"ФормаОтчета2017Кв1");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли
