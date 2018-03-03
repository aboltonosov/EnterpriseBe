﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если ЭтаФорма.Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("ОтчетКомиссионера", ЭтаФорма.Параметры.ПараметрКоманды);
	КонецЕсли;
	
	Параметры = ЭтаФорма.ФормаПараметры;
	
	Если Параметры.Свойство("Отбор")
	   И Параметры.Отбор.Свойство("ОтчетКомиссионера") Тогда
		Если ТипЗнч(Параметры.Отбор.ОтчетКомиссионера) = Тип("ДокументСсылка.ОтчетКомиссионера") Тогда
			Реквизиты = Документы.ОтчетКомиссионера.РеквизитыДокумента(Параметры.Отбор.ОтчетКомиссионера);
			
		ИначеЕсли ТипЗнч(Параметры.Отбор.ОтчетКомиссионера) = Тип("ДокументСсылка.ОтчетКомиссионераОСписании") Тогда
			Реквизиты = Документы.ОтчетКомиссионераОСписании.РеквизитыДокумента(Параметры.Отбор.ОтчетКомиссионера);
			
		Иначе
			Реквизиты = Неопределено;
			
		КонецЕсли;
		Если Реквизиты <> Неопределено Тогда
			Если ЗначениеЗаполнено(Реквизиты.Партнер) Тогда
				Параметры.Отбор.Вставить("Комиссионер", Реквизиты.Партнер);
			КонецЕсли;
			Период = Новый СтандартныйПериод;
			Период.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
			Период.ДатаНачала = Реквизиты.НачалоПериода;
			период.ДатаОкончания = Реквизиты.КонецПериода;
			Параметры.Отбор.Вставить("Период", Период);
		КонецЕсли;
		Параметры.Отбор.Удалить("ОтчетКомиссионера");
	КонецЕсли;
	

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;

	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомиссионерами.Элементы.ТоварыПереданныеНаКомиссию.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомиссионерами.Элементы.ТоварыПереданныеНаКомиссию.Запрос = ТекстЗапроса;	

	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомиссионерами.Элементы.ТоварыПереданныеНаКомиссиюРасход.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения",
																							"АналитикаНоменклатуры.Номенклатура"));
	СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомиссионерами.Элементы.ТоварыПереданныеНаКомиссиюРасход.Запрос = ТекстЗапроса;	
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомиссионерами.Элементы.ЗаказыКлиентов.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВесНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ЗаказыКлиентов.Номенклатура.ЕдиницаИзмерения",
																							"ЗаказыКлиентов.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаОбъемНоменклатуры",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ЗаказыКлиентов.Номенклатура.ЕдиницаИзмерения",
																							"ЗаказыКлиентов.Номенклатура"));
	СхемаКомпоновкиДанных.НаборыДанных.РасчетыСКомиссионерами.Элементы.ЗаказыКлиентов.Запрос = ТекстЗапроса;	
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПолучитьСтруктуруЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	ФиксНастройкаПериода = ФиксированнаяНастройкаПараметра("Период");
	Если ФиксНастройкаПериода.Использование = Истина Тогда
		
		ПользНастройкаПериода = ПользовательскаяНастройкаПараметра("Период");
		ПользНастройкаПериода.Использование = Истина;
		ПользНастройкаПериода.Значение.ДатаНачала = ФиксНастройкаПериода.Значение.ДатаНачала;
		ПользНастройкаПериода.Значение.ДатаОкончания = ФиксНастройкаПериода.Значение.ДатаОкончания;
		
		ФиксНастройкаПериода.Использование = Ложь;
		
	КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);

КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

Функция ФиксированнаяНастройкаПараметра(ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроек.ФиксированныеНастройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Возврат ПараметрДанных;

КонецФункции

Функция ПользовательскаяНастройкаПараметра(ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

Функция ПолучитьСтруктуруЗаголовковПолей()
	
	Возврат КомпоновкаДанныхСервер.СтруктураЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Заказано");
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "ЗаказаноВес");
		КомпоновкаДанныхСервер.УдалитьВыбранноеПолеИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "ЗаказаноОбъем");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли