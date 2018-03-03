﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьОбъект(Объект, СтруктураПараметров) Экспорт

	ЗаполнениеДокументов.Заполнить(Объект, СтруктураПараметров);
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор());
	ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если СтруктураПараметров.ФорматПоПостановлению735 Тогда
		Объект.ДополнительныеСвойства.Вставить("АдресДанныхДляПередачи", АдресХранилища);
	Иначе
		
		СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
		Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("ВыставленныеСчетаФактуры") Тогда
			Объект.ВыставленныеСчетаФактуры.Загрузить(СтруктураДанных.ВыставленныеСчетаФактуры);
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("ПолученныеСчетаФактуры") Тогда
			Объект.ПолученныеСчетаФактуры.Загрузить(СтруктураДанных.ПолученныеСчетаФактуры);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляЗаполнения(ПараметрыДляЗаполнения, АдресХранилища) Экспорт

	Если НЕ ПараметрыДляЗаполнения.ФорматПоПостановлению735 Тогда
		
		ВыставленныеСчетаФактуры = Документы.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.ПустаяСсылка().ВыставленныеСчетаФактуры.ВыгрузитьКолонки();
		ПолученныеСчетаФактуры = Документы.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.ПустаяСсылка().ПолученныеСчетаФактуры.ВыгрузитьКолонки();
		
		ДанныеДляЗаполнения = Новый Структура();
		
		ДанныеДляЗаполнения.Вставить("ВыставленныеСчетаФактуры", ВыставленныеСчетаФактуры);
		ДанныеДляЗаполнения.Вставить("ПолученныеСчетаФактуры", ПолученныеСчетаФактуры);
		
		СведенияОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыДляЗаполнения.Организация);
		НаименованиеОрганизацииДляПечатныхФорм = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОрганизации, "НаименованиеДляПечатныхФорм,");
		ПараметрыДляЗаполнения.Вставить("НаименованиеОрганизацииДляПечатныхФорм",	НаименованиеОрганизацииДляПечатныхФорм);
		
		ПараметрыДляЗаполнения.Вставить("СписокОрганизаций", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьСписокОбособленныхПодразделений(ПараметрыДляЗаполнения.Организация));
		ПараметрыДляЗаполнения.Вставить("ЗаполнениеДокумента", Истина);
		ПараметрыДляЗаполнения.Вставить("ФорматПоПостановлению735", Ложь);
		ПараметрыДляЗаполнения.Вставить("ФормироватьТабличныйДокумент", Истина);
		
		СтруктураЗаписейЖурнала = Отчеты.ЖурналУчетаСчетовФактур.ПолучитьЗаписиЖурналаСчетовФактур(ПараметрыДляЗаполнения);
		
		НомерПП = 1;
		
		ГруппировкаПоИсходнымИИсправительнымЗаписям = СтруктураЗаписейЖурнала.ВыставленныеСчетаФактуры.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ГруппировкаПоИсходнымИИсправительнымЗаписям.Следующий() Цикл
			ГруппировкаПоСчетамФактурам = ГруппировкаПоИсходнымИИсправительнымЗаписям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ГруппировкаПоСчетамФактурам.Следующий() Цикл
				
				ГруппировкаПоРегистратору = ГруппировкаПоСчетамФактурам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ГруппировкаПоРегистратору.Следующий() Цикл
					ГруппировкаПоПризнакуСторно = ГруппировкаПоРегистратору.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ГруппировкаПоПризнакуСторно.Следующий() Цикл
						СчетаФактурыЗаписи = ГруппировкаПоПризнакуСторно.Выбрать();
						Пока СчетаФактурыЗаписи.Следующий() Цикл
							
							НоваяСтрока = ВыставленныеСчетаФактуры.Добавить();
							Отчеты.ЖурналУчетаСчетовФактур.ЗаполнитьСтрокуЖурналаУчетаСчетовФактур(НоваяСтрока, СчетаФактурыЗаписи, ПараметрыДляЗаполнения);
							
							НоваяСтрока.Ном = НомерПП;
							НомерПП = НомерПП + 1;
							
						КонецЦикла;
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
		НомерПП = 1;
		
		Выборка = СтруктураЗаписейЖурнала.ПолученныеСчетаФактуры.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = ПолученныеСчетаФактуры.Добавить();
			
			Отчеты.ЖурналУчетаСчетовФактур.ЗаполнитьСтрокуЖурналаУчетаСчетовФактур(НоваяСтрока, Выборка, ПараметрыДляЗаполнения);
			
			НоваяСтрока.Ном = НомерПП;
			НомерПП = НомерПП + 1;
			
		КонецЦикла;
		
		ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
		
	Иначе
		
		НачалоНалоговогоПериода = УчетНДСПереопределяемый.НачалоНалоговогоПериода(
			ПараметрыДляЗаполнения.Организация, ПараметрыДляЗаполнения.НалоговыйПериод);
			
		ПараметрыРаздела = Новый Структура;
		ПараметрыРаздела.Вставить("Организация",                         ПараметрыДляЗаполнения.Организация);
		ПараметрыРаздела.Вставить("НалоговыйПериод",                     НачалоНалоговогоПериода);
		ПараметрыРаздела.Вставить("КонецПериодаОтчета",                  КонецКвартала(ПараметрыДляЗаполнения.НалоговыйПериод));
		ПараметрыРаздела.Вставить("ГруппироватьПоКонтрагентам",          Ложь);
		ПараметрыРаздела.Вставить("СформироватьОтчетПоСтандартнойФорме", Истина);
		ПараметрыРаздела.Вставить("КонтрагентДляОтбора",                 Справочники.Контрагенты.ПустаяСсылка());
		ПараметрыРаздела.Вставить("ОтбиратьПоКонтрагенту",               Ложь);
		ПараметрыРаздела.Вставить("ВключатьОбособленныеПодразделения",   Истина);
		ПараметрыРаздела.Вставить("ЗаполнениеДекларации",                Ложь);
		ПараметрыРаздела.Вставить("ЗаполнениеДокумента",                 Истина);
		ПараметрыРаздела.Вставить("ФорматПоПостановлению735",            Истина);
		ПараметрыРаздела.Вставить("ФормироватьТабличныйДокумент",        Истина);
		ПараметрыРаздела.Вставить("ЭтоЖурналУчетаСчетовФактур",          Истина);

		ДанныеДляПроверкиКонтрагентов = Новый Структура;
		ДанныеДляПроверкиКонтрагентов.Вставить("ПроверкаКонтрагентовИспользуется", Ложь);
		ПараметрыРаздела.Вставить("ДанныеДляПроверкиКонтрагентов", ДанныеДляПроверкиКонтрагентов);
		
		Отчеты.ЖурналУчетаСчетовФактур.СформироватьОтчет(ПараметрыРаздела, АдресХранилища);

	КонецЕсли;

КонецПроцедуры

Процедура ВосстановитьДанныеДляОтправки(ПараметрыВосстановления,АдресХранилища) Экспорт

	ДокументСсылка = ПараметрыВосстановления.ДокументСсылка;
	ПоместитьВоВременноеХранилище(ДокументСсылка.ПредставлениеОтчета.Получить(), АдресХранилища);

КонецПроцедуры

// Функция поиска документа, относящегося к выбранному налоговому периоду.
//
// Параметры:
//  Организация      - СправочникСсылка.Организации.
//  НалоговыйПериод  - Дата - налоговый период.
//
// Возвращаемое значение:
//  Массив, Неопределено - упорядоченный по дате массив документов.
//
Функция НайтиДокументыЗаНалоговыйПериод(Организация, НалоговыйПериод) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("НачалоНалоговогоПериода",	НачалоКвартала(НалоговыйПериод));
	Запрос.УстановитьПараметр("КонецНалоговогоПериода",		КонецКвартала(НалоговыйПериод));
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде КАК ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде
	|ГДЕ
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Организация = &Организация
	|	И ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.НалоговыйПериод >= &НачалоНалоговогоПериода
	|	И ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.НалоговыйПериод <= &КонецНалоговогоПериода
	|	И НЕ ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Результат	= Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивДокументов	= Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивДокументов;

КонецФункции

#Область ОбработчикиОбновления

// Обработчик обновления на версию 3.0.25.
//
// Процедура заполняет реквизит "ПериодПоСКНП" в тех документах,
// в которых он не заполнен.
//
Процедура ОбработатьДокументыСНезаполненнымРеквизитомПериодПоСКНП() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Ссылка,
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Организация,
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Реорганизация,
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.НалоговыйПериод
	|ИЗ
	|	Документ.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде КАК ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде
	|ГДЕ
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.ПериодПоСКНП = """"
	|	И НЕ ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ОбрабатываемыйДокумент = Выборка.Ссылка;
			
			ОбрабатываемыйОбъект = ОбрабатываемыйДокумент.ПолучитьОбъект();
			ОбрабатываемыйОбъект.ПериодПоСКНП = УчетНДСКлиентСервер.ПолучитьКодПоСКНП(Выборка.НалоговыйПериод, Выборка.Реорганизация);
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбрабатываемыйОбъект);
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать журнала счетов-фактур.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЖурналУчетаСчетовФактур";
	КомандаПечати.Представление = НСтр("ru = 'Печать журнала счетов-фактур'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЖурналУчетаСчетовФактур",
		НСтр("ru = 'Журнал учета счетов-фактур'"),
		ПечатьЖурналаУчетаСчетовФактур(МассивОбъектов, ОбъектыПечати));
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

Функция ПечатьЖурналаУчетаСчетовФактур(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Ссылка,
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Организация,
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.НалоговыйПериод,
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.ВыставленныеСчетаФактуры.(
	|		Ссылка,
	|		НомерСтроки,
	|		ДатаПередачиПолучения,
	|		КодСпособаВыставления,
	|		КодВидаОперации,
	|		НомерСчетаФактуры,
	|		ДатаСчетаФактуры,
	|		НомерКорректировочногоСчетаФактуры,
	|		ДатаКорректировочногоСчетаФактуры,
	|		НомерИсправления,
	|		ДатаИсправления,
	|		КонтрагентНаименование,
	|		КонтрагентИННКПП,
	|		Валюта,
	|		СуммаДокумента,
	|		СуммаНДС,
	|		СуммаДокументаРазницаУменьшение,
	|		СуммаДокументаРазницаУвеличение,
	|		СуммаНДСРазницаУменьшение,
	|		СуммаНДСРазницаУвеличение,
	|		Ном,
	|		СчетФактура
	|	),
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.ПолученныеСчетаФактуры.(
	|		Ссылка,
	|		НомерСтроки,
	|		ДатаПередачиПолучения,
	|		КодСпособаВыставления,
	|		КодВидаОперации,
	|		НомерСчетаФактуры,
	|		ДатаСчетаФактуры,
	|		НомерКорректировочногоСчетаФактуры,
	|		ДатаКорректировочногоСчетаФактуры,
	|		НомерИсправления,
	|		ДатаИсправления,
	|		КонтрагентНаименование,
	|		КонтрагентИННКПП,
	|		Валюта,
	|		СуммаДокумента,
	|		СуммаНДС,
	|		СуммаДокументаРазницаУменьшение,
	|		СуммаДокументаРазницаУвеличение,
	|		СуммаНДСРазницаУменьшение,
	|		СуммаНДСРазницаУвеличение,
	|		Ном,
	|		СчетФактура
	|	),
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Организация.ИНН КАК ОрганизацияИНН,
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Организация.КПП КАК ОрганизацияКПП,
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.ПредставлениеОтчета
	|ИЗ
	|	Документ.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде КАК ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде
	|ГДЕ
	|	ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.Ссылка В(&МассивОбъектов)";
	
	Результат = Запрос.Выполнить();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЖурналУчетаСчетовФактур";
		
	ПервыйДокумент = Истина;
	
	ВыборкаПоОбъектам = Результат.Выбрать();
	
	Пока ВыборкаПоОбъектам.Следующий() Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;

		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВерсияПостановленияНДС1137 = УчетНДСПереопределяемый.ВерсияПостановленияНДС1137(ВыборкаПоОбъектам.НалоговыйПериод);
		Если ВерсияПостановленияНДС1137 = 3 Тогда
			ПредставлениеОтчета = ВыборкаПоОбъектам.ПредставлениеОтчета.Получить();
			Если ПредставлениеОтчета <> Неопределено Тогда 
				ТабличныйДокумент.Вывести(ПредставлениеОтчета);
			КонецЕсли;
			Продолжить;
		Иначе
			Макет = ПолучитьОбщийМакет("ЖурналУчетаСчетовФактур1137");
		КонецЕсли; 

		// ШАПКА
		
		СведенияОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаПоОбъектам.Организация);
		НаименованиеОрганизацииДляПечатныхФорм = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОрганизации, "НаименованиеДляПечатныхФорм,");
		
		Отступ = Макет.ПолучитьОбласть("Отступ");
		Секция = Макет.ПолучитьОбласть("ШапкаИнформация");
		ТабличныйДокумент.Вывести(Секция);
		
		Шапка = Макет.ПолучитьОбласть("Шапка");
		СведенияОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаПоОбъектам.Организация);
		Шапка.Параметры.Организация = НаименованиеОрганизацииДляПечатныхФорм;
		Шапка.Параметры.ИННКПП = "" + ВыборкаПоОбъектам.ОрганизацияИНН + ?(НЕ ЗначениеЗаполнено(ВыборкаПоОбъектам.ОрганизацияКПП), "", ("/" + ВыборкаПоОбъектам.ОрганизацияКПП));
		Шапка.Параметры.Квартал = Формат(ВыборкаПоОбъектам.НалоговыйПериод, "ДФ = к");
		Шапка.Параметры.Год = Формат(ВыборкаПоОбъектам.НалоговыйПериод, "ДФ = гггг");
		
		ТабличныйДокумент.Вывести(Шапка);
		
		ТабличныйДокумент.Вывести(Отступ);
		
		// ЧАСТЬ 1
		
		Часть1Заголовок = Макет.ПолучитьОбласть("Часть1Заголовок");
		ТабличныйДокумент.Вывести(Часть1Заголовок);
		
		Часть1Строка = Макет.ПолучитьОбласть("Часть1Строка");
		
		ВыставленныеСчетаФактуры = ВыборкаПоОбъектам.ВыставленныеСчетаФактуры.Выбрать();
		
		Пока ВыставленныеСчетаФактуры.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Часть1Строка.Параметры, ВыставленныеСчетаФактуры);
			ТабличныйДокумент.Вывести(Часть1Строка);
		КонецЦикла;
		
		
		ТабличныйДокумент.Вывести(Отступ);
		
		// ЧАСТЬ 2
		
		Часть2Заголовок = Макет.ПолучитьОбласть("Часть2Заголовок");
		ТабличныйДокумент.Вывести(Часть2Заголовок);
		
		Часть2Строка = Макет.ПолучитьОбласть("Часть2Строка");
		
		ПолученныеСчетаФактуры = ВыборкаПоОбъектам.ПолученныеСчетаФактуры.Выбрать();
		
		Пока ПолученныеСчетаФактуры.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Часть2Строка.Параметры, ПолученныеСчетаФактуры);
			ТабличныйДокумент.Вывести(Часть2Строка);
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(Отступ);
		
		// ПОДВАЛ
		
		Подвал = Макет.ПолучитьОбласть("Подвал");
		
		СписокПоказателей = Новый Массив;
		СписокПоказателей.Добавить("ФИОРук");
		СписокПоказателей.Добавить("ФИО");
		НалоговыйПериод = КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод);
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			ВыборкаПоОбъектам.Организация, НалоговыйПериод, СписокПоказателей);
		СведенияОЮрФизЛице = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(
			ВыборкаПоОбъектам.Организация, НалоговыйПериод);
		СведенияОбОрганизации.Вставить("Свидетельство", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(
			СведенияОЮрФизЛице, "Свидетельство,"));
		
		Подвал.Параметры.ИмяРук = СведенияОбОрганизации.ФИОРук;
		Подвал.Параметры.ИмяОрг = ?(НЕ РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(
			ВыборкаПоОбъектам.Организация), СведенияОбОрганизации.ФИО, "");
		Подвал.Параметры.Свидетельство = СведенияОбОрганизации.Свидетельство;
		
		ТабличныйДокумент.Вывести(Подвал);
			
		УправлениеКолонтитулами.УстановитьКолонтитулы(ТабличныйДокумент);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент,
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоОбъектам.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область ФормированиеДокументовПоУчетуНДС

Процедура СформироватьДокументыОтчетности(СтруктураПараметров, АдресХранилища) Экспорт

	Результат = УчетНДС.СформироватьДокументыОтчетности(СтруктураПараметров);
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли