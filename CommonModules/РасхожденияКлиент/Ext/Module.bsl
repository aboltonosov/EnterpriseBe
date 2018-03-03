﻿
////////////////////////////////////////////////////////////////////////////////
// Модуль "РасхожденияКлиент" содержит клиентские процедуры и функции для 
// работы документов отражения расхождений после отгрузки.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ФормыСпискаИВыбора

Функция ПараметрыОтбораСпискаДокументовАктаОРасхожденияхПослеОтгрузки() Экспорт
	
	Массив = Новый Массив();
	Массив.Добавить("Валюта");
	Массив.Добавить("Организация");
	Массив.Добавить("Партнер");
	Массив.Добавить("Контрагент");
	
	Возврат Массив;
	
КонецФункции

Функция ПараметрыОтбораСпискаДокументовАктаОРасхожденияхПослеПеремещения() Экспорт
	
	Массив = Новый Массив();
	Массив.Добавить("Организация");
	Массив.Добавить("ОрганизацияПолучатель");
	Массив.Добавить("СкладОтправитель");
	Массив.Добавить("СкладПолучатель");
	
	Возврат Массив;
	
КонецФункции

Процедура АктОРасхожденияхСписокПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, ЭтоАктРасхожденийПослеОтгрузки) Экспорт

	Отказ = Истина;
	
	Если ЭтоАктРасхожденийПослеОтгрузки Тогда
		ТипАктПоУмолчанию = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.РеализацияТоваровУслуг");
		ИмяОткрываемойФормы = "Документ.АктОРасхожденияхПослеОтгрузки.Форма.ФормаДокумента";
	Иначе
		ТипАктПоУмолчанию = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг");
		ИмяОткрываемойФормы = "Документ.АктОРасхожденияхПослеПриемки.Форма.ФормаДокумента";
	КонецЕсли;
	
	ПараметрыОтбора = ПараметрыОтбораСпискаДокументовАктаОРасхожденияхПослеОтгрузки();
	ПараметрыФормы = АктОРасхожденияхСписокПодготовитьПараметрыЗаполнения(Элемент.ТекущаяСтрока, 
		Форма.Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы, ПараметрыОтбора, Копирование);
		
	Если Не Копирование Тогда
		ПараметрыФормы.ЗначенияЗаполнения.Вставить("ТипОснованияАктаОРасхождении",
		                                          ?(ЗначениеЗаполнено(Форма.ТипОснованияАктаОРасхождении),
		                                          Форма.ТипОснованияАктаОРасхождении, 
		                                          ТипАктПоУмолчанию));
	КонецЕсли;
		
	ОткрытьФорму( ИмяОткрываемойФормы, ПараметрыФормы, Форма.Элементы.Список);
	
КонецПроцедуры

// Возвращает данные для заполнения формы нового документа АктОРасхождениях
//
// Параметры:
//  ТекущаяСтрока				 - ДокументСсылка.АктОРасхожденияхПослеОтгрузки, ДокументСсылка.АктОРасхожденияхПослеПеремещения - 
//  ПользовательскиеНастройки	 - КоллекцияЭлементовПользовательскихНастроекКомпоновкиДанных - Настройки формы списка документов
//  ПараметрыОтбора				 - Массив - Массив строк с именами ключевых полей шапки документа
//  Копирование					 - Булево - 
// 
// Возвращаемое значение:
//   - Структура
//
Функция АктОРасхожденияхСписокПодготовитьПараметрыЗаполнения(ТекущаяСтрока, ПользовательскиеНастройки, ПараметрыОтбора, Копирование) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	Если Копирование И ТекущаяСтрока <> Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущаяСтрока);
	Иначе
		
		ОтборПользовательскихНастроек = Неопределено;
		
		Для Каждого ЭлементНастроек Из ПользовательскиеНастройки Цикл
			Если ТипЗнч(ЭлементНастроек) = Тип("ОтборКомпоновкиДанных") Тогда
				ОтборПользовательскихНастроек = ЭлементНастроек;
			КонецЕсли;
		КонецЦикла;
		
		ЗначенияЗаполнения = Новый Структура;
		
		Если ОтборПользовательскихНастроек <> Неопределено Тогда
			
			Для Каждого ЭлементОтбора Из ОтборПользовательскихНастроек.Элементы Цикл
				Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") 
					И ЭлементОтбора.Использование = Истина
					И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
					И ПараметрыОтбора.Найти(Строка(ЭлементОтбора.ЛевоеЗначение)) <> Неопределено Тогда
					
						ЗначенияЗаполнения.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	КонецЕсли;
	
	Возврат ПараметрыФормы;
	
КонецФункции

#КонецОбласти

#Область ШапкаАктовОРасхождениях

Процедура ДокументыОснованиеПредставлениеНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если Форма.ДокументыОснования.Количество() = 1 Тогда
		ПоказатьЗначение(, Форма.ДокументыОснования[0].Реализация);
	ИначеЕсли Форма.ДокументыОснования.Количество() > 1 Тогда
		
		СписокДокументов = Новый СписокЗначений;
		Для Каждого СтрокаТаблицы Из Форма.ДокументыОснования Цикл
			СписокДокументов.Добавить(СтрокаТаблицы.Реализация); 
		КонецЦикла;
		
		Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(Форма.Объект.ТипОснованияАктаОРасхождении) Тогда
			ЗаголовокФормыПросмотра = НСтр("ru='Реализации товаров и услуг (%КоличествоДокументов%)'");
		ИначеЕсли Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента") Тогда
			ЗаголовокФормыПросмотра = НСтр("ru='Возвраты товаров от клиента (%КоличествоДокументов%)'");
		ИначеЕсли Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг") Тогда
			ЗаголовокФормыПросмотра = НСтр("ru='Поступления товаров и услуг (%КоличествоДокументов%)'");
		Иначе
			ЗаголовокФормыПросмотра = НСтр("ru='Возвраты поставщику (%КоличествоДокументов%)'");
		КонецЕсли;
		
		ОткрытьФорму(
		"ОбщаяФорма.ПросмотрСпискаДокументов",
		Новый Структура("СписокДокументов, Заголовок",
		                СписокДокументов,
		                ЗаголовокФормыПросмотра),
		                Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьДокументыОснования(Форма) Экспорт
	
	ПараметрыФормы = СамообслуживаниеКлиент.СтруктураПараметровФормыВыбораОснований();
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, Форма.Объект);
	Если Не Форма.ИспользоватьДоговорыСКлиентами 
		И (РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(Форма.Объект.ТипОснованияАктаОРасхождении)
		   Или Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента")) Тогда
		ПараметрыФормы.УказаниеДоговораНеТребуется = Истина;
	ИначеЕсли Не Форма.ИспользоватьДоговорыСПоставщиками 
		И (Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ВозвратПоставщику")
		   Или Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг")) Тогда
		ПараметрыФормы.УказаниеДоговораНеТребуется = Истина;
	ИначеЕсли Форма.ИспользоватьСоглашенияСКлиентами 
		И (РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(Форма.Объект.ТипОснованияАктаОРасхождении)
		   Или Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента")) Тогда
		ПараметрыФормы.УказаниеДоговораНеТребуется = Не Форма.Элементы.Договор.Видимость;
	ИначеЕсли Форма.ИспользоватьСоглашенияСПоставщиками 
		И (Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ВозвратПоставщику")
		   Или Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг")) Тогда
		ПараметрыФормы.УказаниеДоговораНеТребуется = Не Форма.Элементы.Договор.Видимость;
	Иначе
		ПараметрыФормы.УказаниеДоговораНеТребуется = Не ЗначениеЗаполнено(Форма.Объект.Договор);
	КонецЕсли;
	
	СписокДокументовОснований = Новый СписокЗначений;
	Для Каждого СтрокаТаблицы ИЗ Форма.ДокументыОснования Цикл
		СписокДокументовОснований.Добавить(СтрокаТаблицы.Реализация);
	КонецЦикла;
	
	ПараметрыФормы.ТабличнаяЧастьНеПустая = Форма.Объект.Товары.Количество() > 0;
	ПараметрыФормы.ДокументыОснования = СписокДокументовОснований;
	ПараметрыФормы.ТипОснованияАктаОРасхождении = Форма.Объект.ТипОснованияАктаОРасхождении;
	ОткрытьФорму("Обработка.РаботаСАктамиРасхождений.Форма.ФормаПодбораДокументовОснований",
	             ПараметрыФормы,
	             Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ТабличнаяЧастьТовары

// Устанавливает переданный вариант действия выделенным строкам ТЧ Товары
//
// Параметры:
//  Форма			 - УправляемаяФорма
//  РезультатВыбораПользователя	 - Структура
//
Функция УстановитьВариантДействияВыделеннымСтрокам(Форма, РезультатВыбораПользователя) Экспорт
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("НуженСерверныйВызов", Ложь);
	КоличествоИзмененныхСтрокСоответствие = Новый Соответствие;
	КоличествоИзмененныхСтрокСоответствие.Вставить(РезультатВыбораПользователя.ДействиеНедостачи, 0);
	КоличествоИзмененныхСтрокСоответствие.Вставить(РезультатВыбораПользователя.ДействиеИзлишки, 0);
	
	Если Не ЗначениеЗаполнено(РезультатВыбораПользователя.ДействиеНедостачи)
		И Не ЗначениеЗаполнено(РезультатВыбораПользователя.ДействиеИзлишки) Тогда
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	Для Каждого ВыделеннаяСтрока Из Форма.Элементы.Товары.ВыделенныеСтроки Цикл
		
		ТекущаяСтрока = Форма.Объект.Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		Если НоменклатураКлиентСервер.ВЭтомСтатусеСерииУказываютсяВТЧСерии(ТекущаяСтрока.СтатусУказанияСерий, Форма.ПараметрыУказанияСерий) Тогда
			
			СтруктураВозврата.НуженСерверныйВызов = Истина;
			СтруктураВозврата.Вставить("КоличествоИзмененныхСтрокСоответствие", КоличествоИзмененныхСтрокСоответствие);
			
			Возврат СтруктураВозврата;
			
		Иначе
			
			Если ЗначениеЗаполнено(РезультатВыбораПользователя.ДействиеНедостачи)
				И ТекущаяСтрока.КоличествоУпаковокРасхождения < 0 Тогда
				ВариантДействия = РезультатВыбораПользователя.ДействиеНедостачи;
			Иначе
				ВариантДействия = РезультатВыбораПользователя.ДействиеИзлишки;
			КонецЕсли;
			
			Если РасхожденияКлиентСервер.ИзменитьДействиеВСтроке(ТекущаяСтрока, РезультатВыбораПользователя) Тогда
				КоличествоИзмененныхСтрокСоответствие[ВариантДействия] = КоличествоИзмененныхСтрокСоответствие[ВариантДействия] + 1;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураВозврата;

КонецФункции

Процедура ОповеститьОбУстановкеДействия(КоличествоИзмененныхСтрокСоответствие) Экспорт
	
	ТекстОповещения =  НСтр("ru = 'Изменение варианта действия в строках'");
	Шаблон = НСтр("ru = 'Установлено ""%действие%"" в %КоличествоСтрок%.'");
	ТекстПояснения = "";
	Для Каждого КлючИЗначение Из КоличествоИзмененныхСтрокСоответствие Цикл
		Если КлючИЗначение.Значение > 0 Тогда
			ТекстПояснения = ТекстПояснения + СтрЗаменить(Шаблон, "%действие%", Строка(КлючИЗначение.Ключ));
			ТекстПояснения = СтрЗаменить(ТекстПояснения, "%КоличествоСтрок%",
				СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(КлючИЗначение.Значение,"строке,строках,строках"));
			ТекстПояснения = ТекстПояснения + Символы.ПС;
		КонецЕсли;
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстПояснения) Тогда
		ТекстПояснения = Лев(ТекстПояснения, СтрДлина(ТекстПояснения) - 1);
		ПоказатьОповещениеПользователя(ТекстОповещения,,ТекстПояснения);
	КонецЕсли;
	
КонецПроцедуры
	
Процедура ТоварыДокументОснованияПриИзменении(ТекущаяСтрока, ДокументыОснования) Экспорт

	ЗаказПустаяСсылка = ПредопределенноеЗначение("Документ.ЗаказНаПеремещение.ПустаяСсылка");

	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ТекущаяСтрока.ДокументОснование) Тогда
		ТекущаяСтрока.Заказ = ЗаказПустаяСсылка;
		Возврат;
	КонецЕсли;

	НайденныеСтроки = ДокументыОснования.НайтиСтроки(Новый Структура("ДокументОснование", ТекущаяСтрока.ДокументОснование));
	Если НайденныеСтроки.Количество() = 0 Тогда
		ТекущаяСтрока.Заказ = ЗаказПустаяСсылка;
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = НайденныеСтроки[0];

	Если ЗначениеЗаполнено(ТекущаяСтрока.Заказ) Тогда
		Если НайденнаяСтрока.ЗаказыОснования.НайтиПоЗначению(ТекущаяСтрока.Заказ) = Неопределено Тогда
			ТекущаяСтрока.Заказ = ЗаказПустаяСсылка;
		КонецЕсли;
	КонецЕсли;
	
	РасхожденияКлиентСервер.УстановитьПризнакОснованиеПоЗаказам(ТекущаяСтрока, НайденнаяСтрока);
	РасхожденияКлиентСервер.ЗаполнитьЗаказВСтроке(ТекущаяСтрока, ДокументыОснования);

КонецПроцедуры

Процедура ТоварыПередУдалением(ТекущаяСтрока, Отказ, ЭтоАктРасхожденияхПослеОтгрузки) Экспорт
	
	ИменаРеквизитов = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ЭтоАктРасхожденияхПослеОтгрузки);
	
	Если ТекущаяСтрока[ИменаРеквизитов.ЗаполненоПоОснованию] Тогда
		ТекстПредупреждения =  НСтр("ru = 'Запрещено удалять строки, заполненные по документу-основанию'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Выводит форму редактирования для строкового реквизита табличной части
//
// Параметры:
//  Форма					 - УправляемаяФорма	 - 
//  ИмяПоляКомментарий		 - Строка			 - Наименование реквизита хранящего строку которая будет отредактирована
//  ИмяПоляЕстьКомментарий	 - Строка			 - Наименование булевого реквизита хранящего признак того что поле заполнено
//
Процедура КомментарийНачалоВыбора(Форма, ИмяПоляКомментарий, ИмяПоляЕстьКомментарий, ИмяПоляРедактирования) Экспорт

	ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаКомментарий", ИмяПоляКомментарий);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаЕстьКомментарий", ИмяПоляЕстьКомментарий);
	ДополнительныеПараметры.Вставить("Форма", Форма);

	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("РедактированиеКомментарияЗавершение", РасхожденияКлиент, ДополнительныеПараметры);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(ОписаниеОповещенияЗавершение, Форма.Элементы[ИмяПоляРедактирования].ТекстРедактирования);

КонецПроцедуры

Процедура РедактированиеКомментарияЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	Если РезультатРедактирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Если РезультатРедактирования <> ДополнительныеПараметры.ТекущиеДанные[ДополнительныеПараметры.ИмяРеквизитаКомментарий] Тогда
		ДополнительныеПараметры.ТекущиеДанные[ДополнительныеПараметры.ИмяРеквизитаКомментарий]     = РезультатРедактирования;
		ДополнительныеПараметры.ТекущиеДанные[ДополнительныеПараметры.ИмяРеквизитаЕстьКомментарий] = Не ПустаяСтрока(РезультатРедактирования);
		ДополнительныеПараметры.Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТоварыДействиеНачалоВыбора(ТекущиеДанные, Объект, Форма, ТипАкта, ПоказыватьПояснение = Ложь) Экспорт
	
	Если НЕ ТекущиеДанные.ЕстьРасхождения Тогда
		Возврат;
	КонецЕсли;
	
	Форма.Модифицированность = Истина;
	
	Если Не ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ТипАкта", ТипАкта);
		ПараметрыФормы.Вставить("ВыбранноеДействие", ТекущиеДанные.Действие);
		ПараметрыФормы.Вставить("ГрупповоеИзменение", Ложь);
		ПараметрыФормы.Вставить("КоличествоУпаковокРасхождения", ТекущиеДанные.КоличествоУпаковокРасхождения);
		ПараметрыФормы.Вставить("СпособОтраженияРасхождений", Объект.СпособОтраженияРасхождений);
		ПараметрыФормы.Вставить("СтрокаПоЗаказу", ЗначениеЗаполнено(ТекущиеДанные.КодСтроки));
		ПараметрыФормы.Вставить("ПоказыватьПояснение", ПоказыватьПояснение);
		
		Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки")
			Или ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеПеремещения") Тогда
			ИмяФормы = "Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.Форма.ФормаВыбора";
		Иначе
			ИмяФормы = "Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.Форма.ФормаВыбора";
			ПараметрыФормы.Вставить("ПоВинеСтороннейКомпании", ТекущиеДанные.ПоВинеСтороннейКомпании);
		КонецЕсли;
		
		ОткрытьФорму(
			ИмяФормы,
			ПараметрыФормы,,,,, 
			Новый ОписаниеОповещения("ВыборДействияЗавершение", Форма),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьДействиеВыделенныхСтрок(Объект, Форма, ТипАкта, ПоказыватьПояснение = Ложь) Экспорт
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ТипАкта", ТипАкта);
	ПараметрыФормы.Вставить("ГрупповоеИзменение", Истина);
	ПараметрыФормы.Вставить("СпособОтраженияРасхождений", Объект.СпособОтраженияРасхождений);
	ПараметрыФормы.Вставить("ЕстьИзлишки",   Форма.ЕстьИзлишки);
	ПараметрыФормы.Вставить("ЕстьНедостачи", Форма.ЕстьНедостачи);
	ПараметрыФормы.Вставить("ПоказыватьПояснение", ПоказыватьПояснение);
	
	МассивДействийПоНедостачам = Новый Массив;
	МассивДействийПоИзлишкам   = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Форма.Элементы.Товары.ВыделенныеСтроки Цикл
		
		ЭтоИзлишки   = Ложь;
		ЭтоНедостачи = Ложь;
		
		Действие =  Объект.Товары.НайтиПоИдентификатору(ВыделеннаяСтрока).Действие;
		Если ТипЗнч(Действие) = Тип("ПеречислениеСсылка.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки") Тогда
			
			Если Действие = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ВозвратПерепоставленного")
				Или Действие = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ОприходоватьСейчас")
				Или Действие = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ПерепоставленноеДарится")
				Или Действие = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ПокупкаПерепоставленного") Тогда
				
				ЭтоИзлишки = Истина;
				
			ИначеЕсли ЗначениеЗаполнено(Действие) Тогда
				
				ЭтоНедостачи = Истина;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Действие) = Тип("ПеречислениеСсылка.ВариантыДействийПоРасхождениямВАктеПослеПриемки") Тогда
			
			 Если Действие = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ВернутьПерепоставленноеБезОформления")
				Или Действие = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиПерепоставленноеНаПрочиеДоходы")
				Или Действие = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОформитьПерепоставленноеИВернуть")
				Или Действие = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОформитьПерепоставленное") Тогда
				
				ЭтоИзлишки = Истина;
				
			ИначеЕсли ЗначениеЗаполнено(Действие) Тогда
				
				ЭтоНедостачи = Истина;
				
			КонецЕсли;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
		Если ЭтоИзлишки И МассивДействийПоИзлишкам.Найти(Действие) = Неопределено Тогда
			МассивДействийПоИзлишкам.Добавить(Действие);
		ИначеЕсли ЭтоНедостачи И МассивДействийПоНедостачам.Найти(Действие) = Неопределено Тогда
			МассивДействийПоНедостачам.Добавить(Действие);
		 КонецЕсли;
			
	КонецЦикла;
	
	Если МассивДействийПоИзлишкам.Количество() = 1 Тогда
		ПараметрыФормы.Вставить("ДействиеИзлишки", МассивДействийПоИзлишкам[0]);
	Иначе
		ПараметрыФормы.Вставить("ДействиеИзлишки", Неопределено);
	КонецЕсли;
	
	Если МассивДействийПоНедостачам.Количество() = 1 Тогда
		ПараметрыФормы.Вставить("ДействиеНедостачи", МассивДействийПоНедостачам[0]);
	Иначе
		ПараметрыФормы.Вставить("ДействиеНедостачи", Неопределено);
	КонецЕсли;
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки")
		Или ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеПеремещения") Тогда
		ИмяФормы = "Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.Форма.ФормаВыбора";
	Иначе
		ИмяФормы = "Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.Форма.ФормаВыбора";
	КонецЕсли;
	
	ОткрытьФорму(
		ИмяФормы,
		ПараметрыФормы,,,,, 
		Новый ОписаниеОповещения("ИзменитьДействиеВыделенныхСтрокЗавершение", Форма),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ОткрытьПодбор(Форма, ЭтоАктОРасхожденияхПослеОтгрузки) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(Форма.Объект.ТипОснованияАктаОРасхождении) 
		Или Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента") Тогда
		
		ПараметрЗаголовок = НСтр("ru = 'Подбор товаров в %Документ%'");
		
		Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Форма.Объект.Ссылка);
		Иначе
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru = 'акт о расхождения после'") 
			                                                   + " " 
			                                                   + ?(ЭтоАктОРасхожденияхПослеОтгрузки, 
			                                                       НСтр("ru = 'отгрузки'"),
			                                                       НСтр("ru = 'приемки'")));
		КонецЕсли;
		
		ПараметрыФормы.Вставить("Заголовок", ПараметрЗаголовок);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Соглашение", Форма.Объект.Соглашение);
	ПараметрыФормы.Вставить("Организация", Форма.Объект.Организация);
	ПараметрыФормы.Вставить("ЦенаВключаетНДС", Форма.Объект.ЦенаВключаетНДС);
	ПараметрыФормы.Вставить("Валюта", Форма.Объект.Валюта);
	ПараметрыФормы.Вставить("Дата", Форма.Объект.Дата);
	ПараметрыФормы.Вставить("Документ", Форма.Объект.Ссылка);
	ПараметрыФормы.Вставить("Партнер", Форма.Объект.Партнер);
	ПараметрыФормы.Вставить("СкрыватьРучныеСкидки", Истина);
	
	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(Форма.Объект.ТипОснованияАктаОРасхождении)
		Или Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента") Тогда
		
		Если ЭтоАктОРасхожденияхПослеОтгрузки Тогда
			ПараметрыФормы.Вставить("СегментНоменклатуры", Форма.СегментНоменклатуры);
		КонецЕсли;
		
		ПараметрыФормы.Вставить("РежимПодбораИсключитьГруппыДоступныеВЗаказах", Истина);
		ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах", Истина);
		ПараметрыФормы.Вставить("СкрыватьПодакцизныеТовары", 
		                        Форма.Объект.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД"));
		ПараметрыФормы.Вставить("ОтображатьФлагСкрыватьПодакцизныеТовары", 
		                        Форма.Объект.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД"));
		
		ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);
		
	Иначе
		
		ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры", Новый ФиксированныйМассив(НоменклатураКлиентСервер.ОтборПоТоваруМногооборотнойТаре(Ложь)));
		
		ОткрытьФорму("Обработка.ПодборТоваровВДокументЗакупки.Форма", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОформитьДокументыНажатие(Форма) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если Форма.Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("ОформитьДокументыНажатиеЗавершение", ЭтотОбъект, Новый Структура("Форма", Форма));
		ТекстВопроса = НСтр("ru = 'Акт о расхождениях был изменен. Выполнить перепроведение документа?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОткрытьОформляемыеДокументы(Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОформитьДокументыНажатиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Форма.Записать();
	
	Если Не Форма.Модифицированность Тогда
		ОткрытьОформляемыеДокументы(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьОформляемыеДокументы(Форма)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АктОРасхождениях", Форма.Объект.Ссылка);
	ОткрытьФорму("Обработка.РаботаСАктамиРасхождений.Форма.ОформляемыеДокументы", ПараметрыФормы, Форма);
	
КонецПроцедуры

Процедура ТоварыКоличествоУпаковокПриИзменении(Форма, КэшированныеЗначения) Экспорт
	
	ТекущаяСтрока = Форма.Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СамообслуживаниеКлиентСервер.ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, Форма.Объект);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Если ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.КоличествоУпаковокПоДокументу Тогда
		
		ТекущаяСтрока.Сумма            = ТекущаяСтрока.СуммаПоДокументу;
		ТекущаяСтрока.СуммаРасхождения = 0;
		
	КонецЕсли;
	
	РасхожденияКлиентСервер.РассчитатьИтоговыеПоказателиФормы(Форма);
	
КонецПроцедуры

Процедура ТоварыПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, КэшированныеЗначения) Экспорт
	
	ИменаРеквизитов = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки"));
	
	ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Копирование И ТекущиеДанные[ИменаРеквизитов.ЗаполненоПоОснованию] Тогда
		Отказ = Истина;
		
		НоваяСтрока = Форма.Объект.Товары.Добавить();
		СтрокаИсключаемыхСвойств = ИменаРеквизитов.ЗаполненоПоОснованию 
		                           + ", КоличествоПоДокументу, КоличествоУпаковокПоДокументу, СуммаПоДокументу, СуммаНДСПоДокументу, СуммаСНДСПоДокументу, КодСтроки";
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные, , СтрокаИсключаемыхСвойств);
		Форма.Элементы.Товары.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		РасхожденияКлиент.ТоварыКоличествоУпаковокПриИзменении(Форма, КэшированныеЗначения);
		РасхожденияКлиентСервер.УправлениеДоступностью(Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ТоварыСтавкаНДСПриИзменении(Форма, Элемент, КэшированныеЗначения) Экспорт
	
	ТекущаяСтрока = Форма.Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Форма.Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки") Тогда
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеОтгрузки");
	Иначе
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеПриемки");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	РасхожденияКлиентСервер.РассчитатьИтоговыеПоказателиФормы(Форма);
	
КонецПроцедуры

Процедура ТоварыСуммаПриИзменении(Форма, Элемент, КэшированныеЗначения) Экспорт
	
	ТекущаяСтрока = Форма.Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Форма.Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки") Тогда
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеОтгрузки");
	Иначе
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеПриемки");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	РасхожденияКлиентСервер.РассчитатьИтоговыеПоказателиФормы(Форма);
	
КонецПроцедуры

Процедура ТоварыУпаковкаПриИзменении(Форма, КэшированныеЗначения) Экспорт
	
	ТекущаяСтрока = Форма.Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Форма.Объект);
	
	СтруктураДействий = Новый Структура;
	Если Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг") Тогда
		СтруктураДействий.Вставить("ЗаполнитьНоменклатуруПоставщикаПоНоменклатуре", Форма.Объект.Партнер);
	КонецЕсли;
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	Если ТекущаяСтрока.Количество > 0 Тогда
		СтруктураДействий.Вставить("ПересчитатьЦенуЗаУпаковку", ТекущаяСтрока.Количество);
	ИначеЕсли ЗначениеЗаполнено(Форма.Объект.Соглашение) Тогда
		Если Форма.Объект.ТипОснованияАктаОРасхождении = ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг") Тогда
			СтруктураДействий.Вставить("ЗаполнитьУсловияЗакупок", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияЦеныЗакупкиВСтрокеТЧ(Форма.Объект));
		ИначеЕсли РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(Форма.Объект.ТипОснованияАктаОРасхождении) Тогда
			СтруктураДействий.Вставить("ЗаполнитьУсловияПродаж", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияУсловийПродажВСтрокеТЧ(Форма.Объект));
		КонецЕсли;
	КонецЕсли;
	
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	РасхожденияКлиентСервер.РассчитатьИтоговыеПоказателиФормы(Форма);
	
КонецПроцедуры

Процедура ТоварыЦенаПриИзменении(Форма, Элемент, КэшированныеЗначения) Экспорт
	
	ТекущаяСтрока = Форма.Элементы.Товары.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Форма.Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки") Тогда
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеОтгрузки");
	Иначе
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеПриемки");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	РасхожденияКлиентСервер.РассчитатьИтоговыеПоказателиФормы(Форма);
	
КонецПроцедуры

Процедура ТолькоРасхожденияВыполнить(Форма) Экспорт
	
	Форма.ТолькоРасхождения = Не Форма.ТолькоРасхождения;
	Форма.Элементы.ТоварыТолькоРасхождения.Пометка = Форма.ТолькоРасхождения;
	
	Если Форма.ТолькоРасхождения Тогда
		Форма.Элементы.Товары.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьРасхождения", Истина);
	Иначе
		Форма.Элементы.Товары.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьПредупреждениеДляЗаполненныхНаОснованииСтрок() Экспорт
	
	ТекстСообщения = НСтр("ru = 'Для строк, заполненных на основании возможно редактировать только фактическое количество, номер паспорта и как отработать расхождения (при наличии).'");
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

Процедура ТоварыПослеУдаления(Форма) Экспорт
	
	РасхожденияКлиентСервер.РассчитатьИтоговыеПоказателиФормы(Форма);
	РасхожденияКлиентСервер.УправлениеДоступностью(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыОткрытияФормыЗагрузкиИзВнешнихФайлов(ЗагружатьЦены = Истина) Экспорт
	
	ПараметрыФормы = Новый Структура();
	Если ЗагружатьЦены Тогда
		ПараметрыФормы.Вставить("ЗагружатьЦены", Истина);
	КонецЕсли;
	ПараметрыФормы.Вставить("НеПересчитыватьСуммовыеПоказатели", Истина);
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Загрузка фактического количества товаров из внешнего файла'"));
	
	Возврат ПараметрыФормы;
	
КонецФункции

// Выполняет действие при нажатии гиперссылки в отчете "Оформляемые документы" по документу расхождений
//
// Параметры:
//  Форма               - УправляемаяФорма - форма, из которой происходит вызов 
//  ОписаниеКоманды     - Строка - описание выполяемого действия, "Изменить" или "Оформить"
//  АктОРасхождениях    - Документ.АктОРасхожденияхПослеОтгрузки - отрабатываемый акт о расхождениях.
//  ОснованиеАкта       - Документ.РеализацияТоваровУслуг,
//                      - Документ.ВозвратТоваровПоставщику      - основание акта о расхождениях, по которому выполняются действия
//  ОформляемыйДокумент - тут лежит пока либо пустая ссылка оформляемого типа, либо структура из такой же ссылки и хоз. операции.
//
Процедура ОбработкаКомандыОтчетаОформлениеДокументов(Форма, ОписаниеКоманды, АктОРасхождениях, ОснованиеАкта, ОформляемыйДокумент) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	Если Не РасхожденияВызовСервера.СтатусАктаКВыполнениюОтработано(АктОРасхождениях) Тогда
		ТекстПредупреждения = НСтр("ru = 'Для %ВидДействия% документов акт должен быть в статусе ""Отрабатывается"" или ""Отработано""'");
		ВидДействия = ?(ОписаниеКоманды = "Изменить", НСтр("ru = 'изменения'"), НСтр("ru = 'оформления'"));
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ВидДействия%", ВидДействия);
		ПоказатьПредупреждение( , ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если ОписаниеКоманды = "Изменить" Тогда
		
		РасхожденияВызовСервера.ИзменитьДокументОснованиеАктаОРасхождених(АктОРасхождениях, ОснованиеАкта);
		
	Иначе
		
		Если ТипЗнч(ОформляемыйДокумент) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта", ОснованиеАкта);
			ОткрытьФорму("Документ.ВозвратТоваровОтКлиента.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("Структура")
			И ОформляемыйДокумент.Свойство("ОформляемыйДокумент") 
			И ТипЗнч(ОформляемыйДокумент.ОформляемыйДокумент) = Тип("ДокументСсылка.ВозвратТоваровПоставщику")
			И ОформляемыйДокумент.Свойство("Склад")
			И ЗначениеЗаполнено(ОформляемыйДокумент.Склад) Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта", ОснованиеАкта);
			ПараметрыФормы.Вставить("Склад", ОформляемыйДокумент.Склад);
			ОткрытьФорму("Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта", ОснованиеАкта);
			ОткрытьФорму("Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("РеализацияТоваровУслуг", ОснованиеАкта);
			ОткрытьФорму("Документ.ЗаявкаНаВозвратТоваровОтКлиента.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("ДокументСсылка.КорректировкаПоступления") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта",    ОснованиеАкта); 
			
			ОткрытьФорму("Документ.КорректировкаПоступления.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы));
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("Структура")
			И ОформляемыйДокумент.Свойство("Реализация")
			И ТипЗнч(ОформляемыйДокумент.Реализация) = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("Реализация", ОснованиеАкта);
			ПараметрыФормы.Вставить("Операция",   ОформляемыйДокумент.ХозяйственнаяОперация);
			
			ОткрытьФорму("Документ.КорректировкаРеализации.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы));
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("Структура")
			И ОформляемыйДокумент.Свойство("ОформляемыйДокумент")
			И ТипЗнч(ОформляемыйДокумент.ОформляемыйДокумент) = Тип("ДокументСсылка.ОприходованиеИзлишковТоваров") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта",    ОснованиеАкта);
			ПараметрыФормы.Вставить("Склад",            ОформляемыйДокумент.Склад);
			
			ОткрытьФорму("Документ.ОприходованиеИзлишковТоваров.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("Структура")
			И ОформляемыйДокумент.Свойство("ПеремещениеТоваров")
			И ТипЗнч(ОформляемыйДокумент.ПеремещениеТоваров) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях",   АктОРасхождениях);
			ПараметрыФормы.Вставить("ПеремещениеТоваров", ОснованиеАкта);
			ПараметрыФормы.Вставить("ЭтоПереперемещение", ?(ОформляемыйДокумент.Свойство("ЭтоПереперемещение"), ОформляемыйДокумент.ЭтоПереперемещение, Ложь));
			
			ОткрытьФорму("Документ.ПеремещениеТоваров.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта", ОснованиеАкта);
			ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта", ОснованиеАкта);
			ОткрытьФорму("Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("ДокументСсылка.СписаниеЗадолженности") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта",    ОснованиеАкта);
			ОткрытьФорму("Документ.СписаниеЗадолженности.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		ИначеЕсли ТипЗнч(ОформляемыйДокумент) = Тип("Структура")
			И ОформляемыйДокумент.Свойство("ОформляемыйДокумент")
			И ТипЗнч(ОформляемыйДокумент.ОформляемыйДокумент) = Тип("ДокументСсылка.СписаниеНедостачТоваров") Тогда
			
			ПараметрыФормы.Вставить("АктОРасхождениях", АктОРасхождениях);
			ПараметрыФормы.Вставить("ОснованиеАкта",    ОснованиеАкта);
			ПараметрыФормы.Вставить("Склад",            ОформляемыйДокумент.Склад);
			
			ОткрытьФорму("Документ.СписаниеНедостачТоваров.Форма.ФормаДокумента", Новый Структура("Основание", ПараметрыФормы), Форма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СтруктураПараметровФормыПодбораДокументовОснованийПеремещений() Экспорт

	Структура = Новый Структура("Организация, ОрганизацияПолучатель, СкладОтправитель, СкладПолучатель,
		|ХозяйственнаяОперация, ТабличнаяЧастьНеПустая, ДокументыОснования");

	Возврат Структура;

КонецФункции

#КонецОбласти

#КонецОбласти
