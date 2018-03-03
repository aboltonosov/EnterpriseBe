﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДеревоСпецификаций") Тогда
		
		ТабличныйДокумент = СформироватьПечатныеФормыДереваСпецификаций(МассивОбъектов, ОбъектыПечати, ПараметрыПечати);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ДеревоСпецификаций",
			НСтр("ru = 'Дерево спецификации'"),
			ТабличныйДокумент);
		
	КонецЕсли;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатныеФормыДереваСпецификаций(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ДеревоСпецификацийЗначение = ПолучитьИзВременногоХранилища(ПараметрыПечати.АдресВХранилище);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДеревоСпецификаций";
	
	Макет = Обработки.ДеревоРесурсныхСпецификаций.ПолучитьМакет("ДеревоСпецификаций");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = НСтр("ru = 'Дерево спецификации'");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Уровень = 1;
	ТабДокумент.НачатьАвтогруппировкуСтрок();
	
	Для Каждого Строка Из ДеревоСпецификацийЗначение.Строки Цикл
		
		Количество = Строка.Количество;
		
		ВывестиСтрокуДереваСпецификаций(ТабДокумент, Макет, Строка, Уровень, Количество);
		
	КонецЦикла;
	
	ТабДокумент.ЗакончитьАвтогруппировкуСтрок();
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Возврат ТабДокумент;
	
КонецФункции

Процедура ВывестиСтрокуДереваСпецификаций(ТабДокумент, Макет, СтрокаДерева, Уровень, КоличествоПродукции = 1)
	
	Если СтрокаДерева.ВидСтроки = "МатериалыИУслуги"
		ИЛИ СтрокаДерева.ВидСтроки = "ВыходныеИзделия"
		ИЛИ СтрокаДерева.ВидСтроки = "Трудозатраты" Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("Группа");
		ОбластьМакета.Параметры.Номенклатура = СтрокаДерева.Номенклатура;
	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		ОбластьМакета.Параметры.Заполнить(СтрокаДерева);
	КонецЕсли;
	
	ОбластьСтрока = ТабДокумент.Вывести(ОбластьМакета, Уровень);
	ТабДокумент.Область(ОбластьСтрока.Верх,1+1).Отступ = Уровень - 1;
	
	Если СтрокаДерева.Строки.Количество() > 0 Тогда
		
		Уровень = Уровень + 1;
		
		Для Каждого Строка Из СтрокаДерева.Строки Цикл
			
			ВывестиСтрокуДереваСпецификаций(ТабДокумент, Макет, Строка, Уровень, Строка.Количество);
			
		КонецЦикла;
		
		Уровень = Уровень - 1;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли