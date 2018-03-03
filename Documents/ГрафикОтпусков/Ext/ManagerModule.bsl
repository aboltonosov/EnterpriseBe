﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ГрафикОтпусков);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т7";
	КомандаПечати.Представление = НСтр("ru = 'График отпусков (Т-7)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т7") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПФ_MXL_Т7", НСтр("ru='Форма Т-7'"), ПечатьТ7(МассивОбъектов, ОбъектыПечати), , "Отчет.ГрафикОтпусков.ПФ_MXL_Т7");	
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьТ7(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Унифицированная_форма_Т_7";
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГрафикОтпусковСотрудники.Ссылка КАК Ссылка,
	|	ГрафикОтпусковСотрудники.Ссылка.Дата,
	|	ГрафикОтпусковСотрудники.Ссылка.Номер,
	|	МАКСИМУМ(ГрафикОтпусковСотрудники.ДатаОкончания) КАК ДатаОкончанияПериода,
	|	МИНИМУМ(ГрафикОтпусковСотрудники.ДатаНачала) КАК ДатаНачалаПериода,
	|	ГрафикОтпусковСотрудники.Ссылка.Руководитель КАК Руководитель,
	|	ГрафикОтпусковСотрудники.Ссылка.ДолжностьРуководителя КАК ДолжностьРуководителя,
	|	ГрафикОтпусковСотрудники.Ссылка.РуководительКадровойСлужбы КАК РуководительКадровойСлужбы,
	|	ГрафикОтпусковСотрудники.Ссылка.ДолжностьРуководителяКадровойСлужбы КАК ДолжностьРуководителяКадровойСлужбы
	|ИЗ
	|	Документ.ГрафикОтпусков.Сотрудники КАК ГрафикОтпусковСотрудники
	|ГДЕ
	|	ГрафикОтпусковСотрудники.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГрафикОтпусковСотрудники.Ссылка,
	|	ГрафикОтпусковСотрудники.Ссылка.Дата,
	|	ГрафикОтпусковСотрудники.Ссылка.Номер,
	|	ГрафикОтпусковСотрудники.Ссылка.РуководительКадровойСлужбы,
	|	ГрафикОтпусковСотрудники.Ссылка.ДолжностьРуководителяКадровойСлужбы,
	|	ГрафикОтпусковСотрудники.Ссылка.Руководитель,
	|	ГрафикОтпусковСотрудники.Ссылка.ДолжностьРуководителя";
				   
	Выборка = Запрос.Выполнить().Выбрать();			   
	
	ОтчетТ7 = Отчеты.ГрафикОтпусков.Создать();
	ОтчетТ7.КомпоновщикНастроек.ЗагрузитьНастройки(ОтчетТ7.СхемаКомпоновкиДанных.ВариантыНастроек.Т7.Настройки);
	ОтчетТ7.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КлючВарианта", "Т7");
	
	Пока Выборка.Следующий() Цикл 
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДокументРезультат = Новый ТабличныйДокумент;
			
		НастройкиОтчета = ОтчетТ7.КомпоновщикНастроек.Настройки;	
			
		ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
		Если ПараметрПериод <> Неопределено Тогда
			ПараметрПериод.Значение = Новый СтандартныйПериод(НачалоГода(Выборка.ДатаНачалаПериода), КонецГода(Выборка.ДатаОкончанияПериода));
			ПараметрПериод.Использование = Истина;
		КонецЕсли;
		
		ПараметрДатаОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаДок"));
		Если ПараметрДатаОтчета <> Неопределено Тогда
			ОтчетТ7.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ВосстанавливатьПериод", Истина);
			ПараметрДатаОтчета.Значение = Выборка.Дата; 
			ПараметрДатаОтчета.Использование = Истина;
		Иначе	
			ОтчетТ7.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ВосстанавливатьПериод", Ложь);
		КонецЕсли;
		
		ПараметрДатаОтчета = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НомерДок"));
		Если ПараметрДатаОтчета <> Неопределено Тогда
			ПараметрДатаОтчета.Значение = Выборка.Номер; 
			ПараметрДатаОтчета.Использование = Истина;
		КонецЕсли;
		
		ОтчетТ7.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить(
			"Руководитель", Выборка.Руководитель);		
		ОтчетТ7.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить(
			"ДолжностьРуководителя", Выборка.ДолжностьРуководителя);		
		ОтчетТ7.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить(
			"РуководительКадровойСлужбы", Выборка.РуководительКадровойСлужбы);		
		ОтчетТ7.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить(
			"ДолжностьРуководителяКадровойСлужбы", Выборка.ДолжностьРуководителяКадровойСлужбы);		
		
		Отбор = НастройкиОтчета.Отбор;
		Отбор.Элементы.Очистить();
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ДокументПланирования", ВидСравненияКомпоновкиДанных.Равно, Выборка.Ссылка);
		
		ОтчетТ7.СкомпоноватьРезультат(ДокументРезультат);
		
		ТабличныйДокумент.Вывести(ДокументРезультат);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Проверяет, что сотрудники, указанные в документе работает в периоды отсутствия.
//
// Параметры:
//		ДокументОбъект	- ДокументОбъект.ГрафикОтпусков
//		Отказ			- Булево
//
Процедура ПроверитьРаботающих(ДокументОбъект, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Сотрудники", ДокументОбъект.Сотрудники.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.НомерСтроки,
	|	Сотрудники.Сотрудник,
	|	Сотрудники.ДатаНачала,
	|	Сотрудники.ДатаОкончания
	|ПОМЕСТИТЬ ВТСотрудникиПериоды
	|ИЗ
	|	&Сотрудники КАК Сотрудники";
	
	Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Истина);
	КадровыйУчетРасширенный.СоздатьВТПериодыВКоторыхСотрудникНеРаботал(Запрос.МенеджерВременныхТаблиц);
	УстановитьПривилегированныйРежим(Ложь);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВТСотрудникиПериоды.НомерСтроки КАК НомерСтроки,
	|	ВТСотрудникиПериоды.Сотрудник,
	|	ВТСотрудникиПериоды.ДатаНачала,
	|	ВТСотрудникиПериоды.ДатаОкончания
	|ИЗ
	|	ВТСотрудникиПериоды КАК ВТСотрудникиПериоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПериодыВКоторыхСотрудникНеРаботал КАК ВТПериоды
	|		ПО ВТСотрудникиПериоды.Сотрудник = ВТПериоды.Сотрудник
	|			И ВТСотрудникиПериоды.ДатаНачала = ВТПериоды.ДатаНачала
	|			И ВТСотрудникиПериоды.ДатаОкончания = ВТПериоды.ДатаОкончания
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ДатаНачала = Выборка.ДатаОкончания Тогда
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1 не работает в организации  %2г.'"),
				Выборка.Сотрудник,
				Формат(Выборка.ДатаНачала, "ДЛФ=Д"));
				
			Иначе
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Сотрудник %1 не работает в организации в периоде с %2г. по %3г.'"),
				Выборка.Сотрудник,
				Формат(Выборка.ДатаНачала, "ДЛФ=Д"),
				Формат(Выборка.ДатаОкончания, "ДЛФ=Д"));
				
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Сотрудники[" + Формат(Выборка.НомерСтроки - 1, "ЧГ=") + "].Сотрудник", "Объект", Отказ);
			
		КонецЦикла; 
		
	КонецЕсли; 

КонецПроцедуры

// Устанавливает параметры загрузки.
//
Процедура УстановитьПараметрыЗагрузкиИзФайлаВТЧ(Параметры) Экспорт
	
КонецПроцедуры

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
//
// Параметры:
//   АдресЗагружаемыхДанных    - Строка - Адрес временного хранилища с таблицей значений, в которой
//                                        находятся загруженные данные из файла. Состав колонок:
//     * Идентификатор - Число - Порядковый номер строки;
//     * остальные колонки соответствуют колонкам макета ЗагрузкаИзФайла.
//   АдресТаблицыСопоставления - Строка - Адрес временного хранилища с пустой таблицей значений,
//                                        являющейся копией табличной части документа, 
//                                        которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
//   СписокНеоднозначностей - ТаблицаЗначений - Список неоднозначных значений, для которых в ИБ имеется несколько
//                                              подходящих вариантов.
//     * Колонка       - Строка - Имя колонки, в которой была обнаружена неоднозначность;
//     * Идентификатор - Число  - Идентификатор строки, в которой была обнаружена неоднозначность.
//   ПолноеИмяТабличнойЧасти   - Строка - Полное имя табличной части, в которую загружаются данные.
//   ДополнительныеПараметры   - ЛюбойТип - Любые дополнительные сведения.
//
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	Сотрудники =  ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления);
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеДляСопоставления.Сотрудник КАК СТРОКА(100)) КАК Сотрудник,
		|	ВЫРАЗИТЬ(ДанныеДляСопоставления.ВидОтпуска КАК СТРОКА(100)) КАК ВидОтпуска,
		|	ДанныеДляСопоставления.Идентификатор
		|ПОМЕСТИТЬ ДанныеДляСопоставления
		|ИЗ
		|	&ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(Сотрудники.Ссылка) КАК Сотрудник,
		|	ДанныеДляСопоставления.Идентификатор,
		|	КОЛИЧЕСТВО(ДанныеДляСопоставления.Идентификатор) КАК Количество
		|ИЗ
		|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО (Сотрудники.Наименование = ДанныеДляСопоставления.Сотрудник)
		|			И (НЕ Сотрудники.ВАрхиве)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДляСопоставления.Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВидыОтпусков.Ссылка) КАК ВидОтпуска,
		|	ДанныеДляСопоставления.Идентификатор,
		|	КОЛИЧЕСТВО(ДанныеДляСопоставления.Идентификатор) КАК Количество
		|ИЗ
		|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыОтпусков КАК ВидыОтпусков
		|		ПО (ВидыОтпусков.Наименование = ДанныеДляСопоставления.ВидОтпуска)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДляСопоставления.Идентификатор";

	Запрос.УстановитьПараметр("ДанныеДляСопоставления", ЗагружаемыеДанные);
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	ТаблицаСотрудники 	= РезультатыЗапросов[1].Выгрузить();
	ТаблицаВидыОтпусков = РезультатыЗапросов[2].Выгрузить();

	Для Каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл
		
		СтрокаСотрудник = Сотрудники.Добавить();
		СтрокаСотрудник.Идентификатор 	= СтрокаТаблицы.Идентификатор;
		СтрокаСотрудник.ДатаНачала 		= СтроковыеФункцииКлиентСервер.СтрокаВДату(СтрокаТаблицы.ДатаНачала);
		СтрокаСотрудник.ДатаОкончания 	= СтроковыеФункцииКлиентСервер.СтрокаВДату(СтрокаТаблицы.ДатаОкончания);
		
		СтрокаТаблицыСотрудник = ТаблицаСотрудники.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
		Если СтрокаТаблицыСотрудник <> Неопределено Тогда 
			Если СтрокаТаблицыСотрудник.Количество = 1 Тогда 
				СтрокаСотрудник.Сотрудник = СтрокаТаблицыСотрудник.Сотрудник;
			ИначеЕсли СтрокаТаблицыСотрудник.Количество > 1 Тогда
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор; 
				ЗаписьОНеоднозначности.Колонка = "Сотрудник";
			КонецЕсли;
		КонецЕсли;
		
		СтрокаТаблицыВидыОтпусков = ТаблицаВидыОтпусков.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
		Если СтрокаТаблицыВидыОтпусков <> Неопределено Тогда
			Если СтрокаТаблицыВидыОтпусков.Количество = 1 Тогда 
				СтрокаСотрудник.ВидОтпуска = СтрокаТаблицыВидыОтпусков.ВидОтпуска;
			ИначеЕсли СтрокаТаблицыВидыОтпусков.Количество > 1 Тогда
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор; 
				ЗаписьОНеоднозначности.Колонка = "ВидОтпуска";
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Сотрудники, АдресТаблицыСопоставления);
	
КонецПроцедуры

// Возвращает список подходящих объектов ИБ для неоднозначного значения ячейки.
// 
// Параметры:
//   ПолноеИмяТабличнойЧасти  - Строка - Полное имя табличной части, в которую загружаются данные.
//  ИмяКолонки                - Строка - Имя колонки, в который возникла неоднозначность.
//  СписокНеоднозначностей    - Массив - Массив для заполнения с неоднозначными данными.
//  ЗагружаемыеЗначенияСтрока - Строка - Загружаемые данные на основании которых возникла неоднозначность.
//  ДополнительныеПараметры   - ЛюбойТип - Любые дополнительные сведения
//
Процедура ЗаполнитьСписокНеоднозначностей(ПолноеИмяТабличнойЧасти, СписокНеоднозначностей, ИмяКолонки, ЗагружаемыеЗначенияСтрока, ДополнительныеПараметры) Экспорт
	
	Если ИмяКолонки = "Сотрудник" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Сотрудники.Ссылка
			|ИЗ
			|	Справочник.Сотрудники КАК Сотрудники
			|ГДЕ
			|	Сотрудники.Наименование = &Наименование";
			
		Запрос.УстановитьПараметр("Наименование", ЗагружаемыеЗначенияСтрока.Сотрудник);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокНеоднозначностей.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		
	ИначеЕсли ИмяКолонки = "ВидОтпуска" Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВидыОтпусков.Ссылка
			|ИЗ
			|	Справочник.ВидыОтпусков КАК ВидыОтпусков
			|ГДЕ
			|	ВидыОтпусков.Наименование = &Наименование";
			
		Запрос.УстановитьПараметр("Наименование", ЗагружаемыеЗначенияСтрока.ВидОтпуска);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокНеоднозначностей.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
