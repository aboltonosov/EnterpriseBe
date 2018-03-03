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

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленийШтатногоРасписания,ЧтениеНачисленийШтатногоРасписания", , Ложь) Тогда
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Документ.УтверждениеШтатногоРасписания";
		КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОбУтвержденииШтатногоРасписания";
		КомандаПечати.Представление = НСтр("ru = 'Приказ об утверждении'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ФункциональныеОпции = "ИспользоватьИсториюИзмененияШтатногоРасписания";
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Отчет.ШтатноеРасписаниеНачисления";
		КомандаПечати.Идентификатор = "Т3";
		КомандаПечати.Представление = НСтр("ru = 'Штатное расписание (Т-3)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ФункциональныеОпции = "ИспользоватьИсториюИзмененияШтатногоРасписания";
		
	КонецЕсли; 
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказОбУтвержденииШтатногоРасписания") Тогда
		
		ПечатныеФормы = ПечатнаяФормаПриказа(МассивОбъектов, ОбъектыПечати);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ПФ_MXL_ПриказОбУтвержденииШтатногоРасписания", 
			НСтр("ru = 'Приказ об утверждении'"), 
			ПечатныеФормы, ,
			"Документ.УтверждениеШтатногоРасписания.ПФ_MXL_ПриказОбУтвержденииШтатногоРасписания");
			
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаПриказа(МассивОбъектов, ОбъектыПечати)
	
	ТДокумент = Новый ТабличныйДокумент;
	
	ТабличныеДокументыТ3 = Отчеты.ШтатноеРасписаниеНачисления.ПечатьШтатногоРасписанияТ3(МассивОбъектов, ОбъектыПечати);
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.УтверждениеШтатногоРасписания.ПФ_MXL_ПриказОбУтвержденииШтатногоРасписания");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьУтратилСилу = Макет.ПолучитьОбласть("УтратилСилу");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ДанныеДляПечати = ДанныеДляПечатиПриказов(МассивОбъектов);
	Пока ДанныеДляПечати.Следующий() Цикл
		
		Если ТДокумент.ВысотаТаблицы > 0 Тогда
			ТДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли; 
		
		НачалоФормы = ТДокумент.ВысотаТаблицы + 1;
		
		ТДТ3 = Неопределено;
		Если ОбъектыПечати <> Неопределено Тогда
			ЗначениеОбъектаПечати = ОбъектыПечати.НайтиПоЗначению(ДанныеДляПечати.Ссылка);
			Если ЗначениеОбъектаПечати <> Неопределено Тогда
				ТДТ3 = Новый ТабличныйДокумент;
				ЗаполнитьЗначенияСвойств(ТДТ3, ТабличныеДокументыТ3, "АвтоМасштаб,МасштабПечати,ОриентацияСтраницы,ПолеСверху,ПолеСлева,ПолеСнизу,ПолеСправа,РазмерКолонтитулаСверху,РазмерКолонтитулаСнизу");
				ТДТ3.Вывести(ТабличныеДокументыТ3.ПолучитьОбласть(ЗначениеОбъектаПечати.Представление));
			КонецЕсли;
		КонецЕсли; 
		
		НомерПункта = 2;
		
		ОбластьШапка.Параметры.Заполнить(ДанныеДляПечати);
		
		Если НастройкиПечатныхФорм.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов Тогда
			ОбластьШапка.Параметры.НомерДок = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ОбластьШапка.Параметры.НомерДок, Истина, Истина);
		КонецЕсли;
		
		ОбластьШапка.Параметры.ДатаДок = Формат(ОбластьШапка.Параметры.ДатаДок, "ДЛФ=DD");
		
		ОбластьШапка.Параметры.МесяцВступленияВСилу = Формат(ОбластьШапка.Параметры.МесяцВступленияВСилу, "ДФ='дд ММММ гггг'");
		ПервыйПробел = СтрНайти(ОбластьШапка.Параметры.МесяцВступленияВСилу, " ");
		ОбластьШапка.Параметры.МесяцВступленияВСилу = СокрЛП(Сред(ОбластьШапка.Параметры.МесяцВступленияВСилу, ПервыйПробел));
		
		ТДокумент.Вывести(ОбластьШапка);
		
		Если ЗначениеЗаполнено(ДанныеДляПечати.НомерДокПредыдущийПриказ) Тогда
			
			НомерПункта = 3;
			ОбластьУтратилСилу.Параметры.Заполнить(ДанныеДляПечати);
			ОбластьУтратилСилу.Параметры.НомерДокПредыдущийПриказ = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ОбластьУтратилСилу.Параметры.НомерДокПредыдущийПриказ, Истина, Истина);
			ОбластьУтратилСилу.Параметры.ДатаДокПредыдущийПриказ = Формат(ОбластьУтратилСилу.Параметры.ДатаДокПредыдущийПриказ, "ДЛФ=DD");
			ТДокумент.Вывести(ОбластьУтратилСилу);
			
		КонецЕсли; 
		
		ОбластьПодвал.Параметры.Заполнить(ДанныеДляПечати);
		ОбластьПодвал.Параметры.НомерПункта = НомерПункта;
		
		Если ЗначениеЗаполнено(ОбластьПодвал.Параметры.ФИОИсполнителя) Тогда
			РезультатСклонения = "";
			Если ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ОбластьПодвал.Параметры.ФИОИсполнителя), 4, РезультатСклонения, ДанныеДляПечати.ПолИсполнителя) Тогда
				ОбластьПодвал.Параметры.ФИОИсполнителя = РезультатСклонения
			КонецЕсли;
		Иначе
			ОбластьПодвал.Параметры.ФИОИсполнителя = "____________________";
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(ОбластьПодвал.Параметры.ДолжностьИсполнителя) Тогда
			ОбластьПодвал.Параметры.ДолжностьИсполнителя = "____________________";
		КонецЕсли; 
		
		Если ТДТ3 = Неопределено Тогда
			ОбластьПодвал.Параметры.КоличествоЛистов = "____";
			ОбластьПодвал.Параметры.КоличествоЛистовПрописью = "________________________________________";
		Иначе
			
			ОбластьПодвал.Параметры.КоличествоЛистов = ТДТ3.КоличествоСтраниц();
			ОбластьПодвал.Параметры.КоличествоЛистовПрописью = СокрЛП(НРег(ЧислоПрописью(
				ОбластьПодвал.Параметры.КоличествоЛистов,
				"Л=ru_RU",
				",,,м,,,,,0")));
			
		КонецЕсли;
		
		ТДокумент.Вывести(ОбластьПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТДокумент, НачалоФормы, ОбъектыПечати, ДанныеДляПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТДокумент;
	
КонецФункции

Функция ДанныеДляПечатиПриказов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УтверждениеШтатногоРасписания.Ссылка,
		|	УтверждениеШтатногоРасписания.Номер КАК НомерДок,
		|	УтверждениеШтатногоРасписания.Дата КАК Дата,
		|	УтверждениеШтатногоРасписания.Дата КАК ДатаДок,
		|	УтверждениеШтатногоРасписания.МесяцВступленияВСилу,
		|	УтверждениеШтатногоРасписания.Руководитель,
		|	УтверждениеШтатногоРасписания.ДолжностьРуководителя,
		|	УтверждениеШтатногоРасписания.РуководительКадровойСлужбы КАК РуководительКадровойСлужбы,
		|	УтверждениеШтатногоРасписания.ДолжностьРуководителяКадровойСлужбы КАК ДолжностьРуководителяКадровойСлужбы,
		|	УтверждениеШтатногоРасписания.Организация,
		|	ВЫРАЗИТЬ(УтверждениеШтатногоРасписания.Организация.НаименованиеПолное КАК СТРОКА(1000)) КАК ОрганизацияНаименованиеПолное,
		|	ВЫРАЗИТЬ(УтверждениеШтатногоРасписания.Организация.НаименованиеСокращенное КАК СТРОКА(1000)) КАК ОрганизацияНаименованиеСокращенное
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.УтверждениеШтатногоРасписания КАК УтверждениеШтатногоРасписания
		|ГДЕ
		|	УтверждениеШтатногоРасписания.Ссылка В(&МассивОбъектов)";
		
	Запрос.Выполнить();
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, "Руководитель,РуководительКадровойСлужбы", "ВТДанныеДокументов");
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокументов.Ссылка,
		|	ДанныеДокументов.НомерДок,
		|	ДанныеДокументов.ДатаДок,
		|	ДанныеДокументов.МесяцВступленияВСилу,
		|	ФИОРуководителя.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи,
		|	ДанныеДокументов.ДолжностьРуководителя,
		|	ФИОИсполнителя.ФИОПолные КАК Исполнитель,
		|	ВЫРАЗИТЬ(ДанныеДокументов.РуководительКадровойСлужбы КАК Справочник.ФизическиеЛица).Пол КАК ПолИсполнителя,
		|	ДанныеДокументов.ДолжностьРуководителяКадровойСлужбы КАК ДолжностьИсполнителя,
		|	ДанныеДокументов.Организация,
		|	ДанныеДокументов.ОрганизацияНаименованиеПолное,
		|	ДанныеДокументов.ОрганизацияНаименованиеСокращенное,
		|	МАКСИМУМ(УтверждениеШтатногоРасписания.МесяцВступленияВСилу) КАК МесяцВступленияВСилуПредыдущий
		|ПОМЕСТИТЬ ВТДанныеДокументаСПредыдущимМесяцем
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УтверждениеШтатногоРасписания КАК УтверждениеШтатногоРасписания
		|		ПО ДанныеДокументов.МесяцВступленияВСилу > УтверждениеШтатногоРасписания.МесяцВступленияВСилу
		|			И (УтверждениеШтатногоРасписания.Проведен)
		|			И ДанныеДокументов.Организация = УтверждениеШтатногоРасписания.Организация
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИОРуководителя
		|		ПО ДанныеДокументов.Ссылка = ФИОРуководителя.Ссылка
		|			И ДанныеДокументов.Руководитель = ФИОРуководителя.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИОИсполнителя
		|		ПО ДанныеДокументов.Ссылка = ФИОИсполнителя.Ссылка
		|			И ДанныеДокументов.РуководительКадровойСлужбы = ФИОИсполнителя.ФизическоеЛицо
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДокументов.Ссылка,
		|	ДанныеДокументов.НомерДок,
		|	ДанныеДокументов.ДатаДок,
		|	ДанныеДокументов.МесяцВступленияВСилу,
		|	ФИОРуководителя.РасшифровкаПодписи,
		|	ДанныеДокументов.ДолжностьРуководителя,
		|	ФИОИсполнителя.ФИОПолные,
		|	ДанныеДокументов.ДолжностьРуководителяКадровойСлужбы,
		|	ДанныеДокументов.ОрганизацияНаименованиеПолное,
		|	ДанныеДокументов.ОрганизацияНаименованиеСокращенное,
		|	ДанныеДокументов.Организация,
		|	ВЫРАЗИТЬ(ДанныеДокументов.РуководительКадровойСлужбы КАК Справочник.ФизическиеЛица).Пол
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокументаСПредыдущимМесяцем.Ссылка КАК Ссылка,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДанныеДокументаСПредыдущимМесяцем.Ссылка) КАК ПредставлениеСсылки,
		|	ДанныеДокументаСПредыдущимМесяцем.НомерДок,
		|	ДанныеДокументаСПредыдущимМесяцем.ДатаДок,
		|	ДанныеДокументаСПредыдущимМесяцем.МесяцВступленияВСилу,
		|	ДанныеДокументаСПредыдущимМесяцем.РуководительРасшифровкаПодписи,
		|	ДанныеДокументаСПредыдущимМесяцем.ДолжностьРуководителя,
		|	ДанныеДокументаСПредыдущимМесяцем.Исполнитель КАК ФИОИсполнителя,
		|	ДанныеДокументаСПредыдущимМесяцем.ПолИсполнителя,
		|	ДанныеДокументаСПредыдущимМесяцем.ДолжностьИсполнителя,
		|	ДанныеДокументаСПредыдущимМесяцем.ОрганизацияНаименованиеПолное,
		|	ДанныеДокументаСПредыдущимМесяцем.ОрганизацияНаименованиеСокращенное,
		|	УтверждениеШтатногоРасписания.Номер КАК НомерДокПредыдущийПриказ,
		|	УтверждениеШтатногоРасписания.Дата КАК ДатаДокПредыдущийПриказ
		|ИЗ
		|	ВТДанныеДокументаСПредыдущимМесяцем КАК ДанныеДокументаСПредыдущимМесяцем
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УтверждениеШтатногоРасписания КАК УтверждениеШтатногоРасписания
		|		ПО ДанныеДокументаСПредыдущимМесяцем.МесяцВступленияВСилуПредыдущий = УтверждениеШтатногоРасписания.МесяцВступленияВСилу
		|			И ДанныеДокументаСПредыдущимМесяцем.Организация = УтверждениеШтатногоРасписания.Организация
		|			И (УтверждениеШтатногоРасписания.Проведен)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка";
		
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

#КонецЕсли
