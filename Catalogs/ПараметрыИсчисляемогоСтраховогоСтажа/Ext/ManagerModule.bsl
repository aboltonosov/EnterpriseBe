﻿#Область СлужебныеПроцедурыИФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура НачальноеЗаполнение() Экспорт
	
	ОбновитьОбъектКлассификатора("АДМИНИСТР",	"Отпуск без сохранения содержания");
	ОбновитьОбъектКлассификатора("ВАХТА",		"Время вахтового отдыха");
	ОбновитьОбъектКлассификатора("ВРНЕТРУД",	"Период временной нетрудоспособности");
	ОбновитьОбъектКлассификатора("ДЕКРЕТ",		"Отпуск по беременности и родам");
	ОбновитьОбъектКлассификатора("ДЕТИ",		"Отпуск по уходу за ребенком");
	ОбновитьОбъектКлассификатора("ДЛДЕТИ",		"Отпуск по уходу за ребенком (ДЛДЕТИ)");
	ОбновитьОбъектКлассификатора("ДЛОТПУСК",	"Пребывание в оплачиваемом отпуске");
	ОбновитьОбъектКлассификатора("ДОГОВОР",		"Период работы по договору гражданско-правового характера");
	ОбновитьОбъектКлассификатора("ДОПВЫХ",		"Дополнительные выходные дни лицам, осуществляющим уход за детьми-инвалидами");
	ОбновитьОбъектКлассификатора("КВАЛИФ",		"Повышение квалификации с отрывом от производства");
	ОбновитьОбъектКлассификатора("МЕДНЕТРУД",	"Перевод беременной женщины с работы, право на досрочную пенсию, на работу, исключающую воздействие неблагоприятных производственных факторов");
	ОбновитьОбъектКлассификатора("МЕСЯЦ",		"Перевод по произв. необходимости на срок не более одного месяца с работы, дающей право на досрочную пенсию, на другую работу, не дающую на это право");
	ОбновитьОбъектКлассификатора("НЕОПЛ",		"Неоплачиваемый период");
	ОбновитьОбъектКлассификатора("НЕОПЛАВТ",	"Период работы по авторскому договору, выплаты и иные вознаграждения за который начислены в следующие отчетные периоды");
	ОбновитьОбъектКлассификатора("НЕОПЛДОГ",	"Период работы по договору гражданско-правового характера, выплаты и иные вознаграждения за который начислены в следующие отчетные периоды");
	ОбновитьОбъектКлассификатора("ОБЩЕСТ",		"Исполнение государственных или общественных обязанностей");
	ОбновитьОбъектКлассификатора("ОТСТРАН",		"Отстранение от работы (недопущение к работе) не по вине работника");
	ОбновитьОбъектКлассификатора("ПРОСТОЙ",		"Время простоя по вине работодателя");
	ОбновитьОбъектКлассификатора("СДКРОВ",		"Дни сдачи крови и ее компонентов и предоставленные в связи с этим дни отдыха");
	ОбновитьОбъектКлассификатора("УЧОТПУСК",	"Дополнительные отпуска работникам, совмещающим работу с обучением");
	ОбновитьОбъектКлассификатора("ЧАЭС",		"Доп. отпуск, пострадавших в аварии на Чернобыльской АЭС");
	
	УстановитьРеквизитыИспользования2014ПараметровСтраховогоСтажа();
	УстановитьРеквизитыИспользования2014ДляНовыхПараметровСтраховогоСтажа();
	УстановитьРеквизитыИспользования2015();
	
КонецПроцедуры

Процедура УстановитьРеквизитыИспользования2014ПараметровСтраховогоСтажа()
	
	ОбновитьОбъектКлассификатора("ВАХТА",		"Время вахтового отдыха", Истина);
	ОбновитьОбъектКлассификатора("МЕСЯЦ",		"Перевод по произв. необходимости на срок не более одного месяца с работы, дающей право на досрочную пенсию, на другую работу, не дающую на это право", Истина);
	ОбновитьОбъектКлассификатора("КВАЛИФ",		"Повышение квалификации с отрывом от производства", Истина);
	ОбновитьОбъектКлассификатора("ОБЩЕСТ",		"Исполнение государственных или общественных обязанностей", Истина);
	ОбновитьОбъектКлассификатора("СДКРОВ",		"Дни сдачи крови и ее компонентов и предоставленные в связи с этим дни отдыха", Истина);
	ОбновитьОбъектКлассификатора("ОТСТРАН", 	"Отстранение от работы (недопущение к работе) не по вине работника", Истина);
	ОбновитьОбъектКлассификатора("ПРОСТОЙ", 	"Время простоя по вине работодателя", Истина);
	ОбновитьОбъектКлассификатора("УЧОТПУСК",	"Дополнительные отпуска работникам, совмещающим работу с обучением", Истина);
	
КонецПроцедуры	

Процедура УстановитьРеквизитыИспользования2014ДляНовыхПараметровСтраховогоСтажа() Экспорт 
	
	ОбновитьОбъектКлассификатора("МЕДНЕТРУД",	"Перевод беременной женщины с работы, право на досрочную пенсию, на работу, исключающую воздействие неблагоприятных производственных факторов", Истина);
	ОбновитьОбъектКлассификатора("НЕОПЛАВТ",	"Период работы по авторскому договору, выплаты и иные вознаграждения за который начислены в следующие отчетные периоды", Истина);
	ОбновитьОбъектКлассификатора("НЕОПЛДОГ",	"Период работы по договору гражданско-правового характера, выплаты и иные вознаграждения за который начислены в следующие отчетные периоды", Истина);
	
КонецПроцедуры	

Процедура УстановитьРеквизитыИспользования2015() Экспорт 
	
	ОбновитьОбъектКлассификатора("ДЕТИПРЛ", "Отпуск по уходу за ребенком до трех лет, предоставляемый бабушке, деду, другим родственникам или опекунам, фактически осуществляющим уход за ребенком", Истина);
	
КонецПроцедуры	

Процедура ОбновитьОбъектКлассификатора(ИмяПредопределенныхДанных, Наименование, ИспользуетсяС2014Года = Ложь) 
	
	СсылкаПредопределенного = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПараметрыИсчисляемогоСтраховогоСтажа." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Элемент = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Элемент = Справочники.ПараметрыИсчисляемогоСтраховогоСтажа.СоздатьЭлемент();
		Элемент.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;
	
	Элемент.Код = ИмяПредопределенныхДанных;
	Элемент.Наименование = Наименование;

	Элемент.ИспользуетсяС2014Года = ИспользуетсяС2014Года;
	
	Элемент.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");	
	Элемент.Записать();
	
КонецПроцедуры	

#КонецЕсли

#КонецОбласти
