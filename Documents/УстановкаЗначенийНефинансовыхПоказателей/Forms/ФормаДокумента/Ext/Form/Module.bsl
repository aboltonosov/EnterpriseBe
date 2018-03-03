﻿&НаКлиенте
Перем ИзменениеСуществующейСтроки;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьЗначенияКолонокПоУмолчанию();
	Иначе
		Если Параметры.Свойство("НФП_ЗаполнитьЗначенияПоУмолчанию") и Не ТабличнаяЧасть.Количество() Тогда
			ЗаполнитьЗначенияКолонокПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	УстановитьФормуДокумента();
	
	ВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	Если Объект.Ссылка.Пустая() Тогда
		СтруктураОписания = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
		Если СтруктураОписания <> Неопределено Тогда
			Если СтруктураОписания.Период = "ДействуетС" Тогда
				Объект.НачалоПериода = ТекущаяДата();
			ИначеЕсли ЗначениеЗаполнено(Периодичность) Тогда
				Объект.НачалоПериода = БюджетированиеКлиентСервер.ДатаНачалаПериода(ТекущаяДата(), Периодичность);
				Если Элементы.СтраницыОкончаниеПериода.ТекущаяСтраница = Элементы.ОкончаниеПериодаЭлемент Тогда
					Объект.ОкончаниеПериода = БюджетированиеКлиентСервер.ДатаКонцаПериода(ТекущаяДата(), Периодичность);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьЗначенияСтрокПоУмолчанию();
		УстановитьЗначенияИзАналитикиПоСтрокам(Неопределено, Истина, Истина);
	Иначе
		Если Параметры.Свойство("НФП_ЗаполнитьЗначенияПоУмолчанию") и Не ТабличнаяЧасть.Количество() Тогда
			ЗаполнитьЗначенияСтрокПоУмолчанию();
			УстановитьЗначенияИзАналитикиПоСтрокам(Неопределено, Истина, Истина);
			Модифицированность = Истина;
		Иначе
			ВосстановитьТабличнуюЧастьДокумента();
			УстановитьЗначенияИзАналитикиПоСтрокам(Неопределено, Ложь, Истина);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	Элементы.НастроитьФорму.Видимость = ПравоДоступа("Добавление", Метаданные.Справочники.ШаблоныВводаНефинансовыхПоказателей);
	Элементы.Показатели.ТолькоПросмотр = ЭтаФорма.ТолькоПросмотр;
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СтруктураОписанияВвода = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
	
	Если СтруктураОписанияВвода <> Неопределено Тогда
		ПроверитьЗаполнениеДокумента(СтруктураОписанияВвода, Отказ);
		СохранитьТабличнуюЧастьВДокумент(СтруктураОписанияВвода, ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УстановкаЗначенийНФП", , Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НефинансовыйПоказательПриИзменении(Элемент)
	
	ПерерисоватьФорму(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	ВидОперацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонВводаПриИзменении(Элемент)
	
	ТабличнаяЧасть.Количество();
	УстановитьНовыйШаблонНаСервере(Объект.ШаблонВвода);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал()
	
	ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода", Объект.НачалоПериода, Объект.ОкончаниеПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактироватьПериодЗавершение", ЭтаФорма);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбораПериода, Элементы.УстановитьИнтервал, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	Если Элементы.СтраницыОкончаниеПериода.ТекущаяСтраница = Элементы.ОкончаниеПериодаЭлемент Тогда
		Объект.НачалоПериода = БюджетированиеКлиентСервер.ДатаНачалаПериода(Объект.НачалоПериода, Периодичность);
		ПерерисоватьФорму();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПериода1ПриИзменении(Элемент)
	
	Объект.ОкончаниеПериода = БюджетированиеКлиентСервер.ДатаКонцаПериода(Объект.ОкончаниеПериода, Периодичность);
	
	ПерерисоватьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииАналитикиШапки(Элемент)
	
	Если Не БюджетнаяОтчетностьКлиентСервер.ЛеваяЧастьИмениСовпадает(Элемент.Имя, "Аналитика") Тогда
		Возврат;
	КонецЕсли;
	
	НомерАналитики = Число(СтрЗаменить(Элемент.Имя, "Аналитика", ""));
	ПараметрыОтбора = Новый Структура("АдресАналитикиВалюта", НомерАналитики);
	АналитикаИспользуетсяВВалюта = КэшСвойствПоказателей.НайтиСтроки(ПараметрыОтбора).Количество() > 0;
	ПараметрыОтбора = Новый Структура("АдресАналитикиКоличество", НомерАналитики);
	АналитикаИспользуетсяВКоличестве = КэшСвойствПоказателей.НайтиСтроки(ПараметрыОтбора).Количество() > 0;
	
	Если АналитикаИспользуетсяВВалюта ИЛИ АналитикаИспользуетсяВКоличестве Тогда
		УстановитьЗначенияИзАналитикиПоСтрокам(Элемент.Имя, АналитикаИспользуетсяВВалюта, АналитикаИспользуетсяВКоличестве);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ТабличнаяЧастьПриИзменении(Элемент)
	
	Если ИзменениеСуществующейСтроки = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы из ТабличнаяЧасть Цикл
		СтрокаТаблицы.НомерСтрокиДокумента = ТабличнаяЧасть.Индекс(СтрокаТаблицы) + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗначениеЗаполнено(Объект.НефинансовыйПоказатель)
		И Не ЗначениеЗаполнено(Объект.ШаблонВвода) Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Укажите нефинансовый показатель или шаблон ввода'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ИзменениеСуществующейСтроки = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПередНачаломИзменения(Элемент, Отказ)
	
	//установка флага, что бы при изменении существующей строки
	//не пересчитывались номера строк
	ИзменениеСуществующейСтроки = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	//установка флага, что бы после добавления новой строки
	//при изменении ячеек не пересчитывались номера строк
	ИзменениеСуществующейСтроки = Истина;
	
	ТабличнаяЧастьПриНачалеРедактированияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНастройкамНефинансовогоПоказателя(Команда)
	
	Если ТабличнаяЧасть.Количество() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборРежимаОчисткиСтрок", ЭтаФорма);
		ТекстВопроса = НСтр("ru = 'Удалить существующие строки?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		Модифицированность = Истина;
		ЗаполнитьНаСервере(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Перем НомерСтрокиДубля;
	
	Если Не ОтменаРедактирования Тогда
		Если НоваяСтрока и СтрокаДублируетСуществующую(Элемент.ТекущаяСтрока, НомерСтрокиДубля) Тогда
			ТекстСообщения = НСтр("ru = 'Нельзя вводить строки с одинаковой аналитикой.
										|Указанные аналитики уже встречаются в строке №%1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НомерСтрокиДубля);
			ПоказатьПредупреждение(, ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначенияКолонокАналитика1(Команда)
	
	ПараметрыФормы = ПараметрыФормыСпискаРедактирования(1);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗначенийКолонок", ЭтаФорма, ПараметрыФормы);
	ОткрытьФорму("ОбщаяФорма.РедактированиеСпискаЗначений", ПараметрыФормы, , , , , ОписаниеОповещения,
															РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначенияКолонокАналитика2(Команда)
	
	ПараметрыФормы = ПараметрыФормыСпискаРедактирования(2);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗначенийКолонок", ЭтаФорма, ПараметрыФормы);
	ОткрытьФорму("ОбщаяФорма.РедактированиеСпискаЗначений", ПараметрыФормы, , , , , ОписаниеОповещения,
															РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначенияКолонокАналитика3(Команда)
	
	ПараметрыФормы = ПараметрыФормыСпискаРедактирования(3);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗначенийКолонок", ЭтаФорма, ПараметрыФормы);
	ОткрытьФорму("ОбщаяФорма.РедактированиеСпискаЗначений", ПараметрыФормы, , , , , ОписаниеОповещения,
															РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначенияКолонокАналитика4(Команда)
	
	ПараметрыФормы = ПараметрыФормыСпискаРедактирования(4);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗначенийКолонок", ЭтаФорма, ПараметрыФормы);
	ОткрытьФорму("ОбщаяФорма.РедактированиеСпискаЗначений", ПараметрыФормы, , , , , ОписаниеОповещения,
															РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначенияКолонокАналитика5(Команда)
	
	ПараметрыФормы = ПараметрыФормыСпискаРедактирования(5);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗначенийКолонок", ЭтаФорма, ПараметрыФормы);
	ОткрытьФорму("ОбщаяФорма.РедактированиеСпискаЗначений", ПараметрыФормы, , , , , ОписаниеОповещения,
															РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначенияКолонокАналитика6(Команда)
	
	ПараметрыФормы = ПараметрыФормыСпискаРедактирования(6);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗначенийКолонок", ЭтаФорма, ПараметрыФормы);
	ОткрытьФорму("ОбщаяФорма.РедактированиеСпискаЗначений", ПараметрыФормы, , , , , ОписаниеОповещения,
															РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииКолонкиСписка(Элемент)
	
	Если Не БюджетнаяОтчетностьКлиентСервер.ЛеваяЧастьИмениСовпадает(Элемент.Имя, "Аналитика") Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииКолонкиСпискаНаСервере(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьФорму(Команда)
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону") Тогда
		Если ШаблонИспользуетсяВДокументах(Объект.ШаблонВвода, Объект.Ссылка) Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("СозданиеНовогоШаблона", ЭтаФорма);
			ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Шаблон используется в документах - редактирование недоступно.
															|Создать новый шаблон?'"), РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
		ПараметрыФормы = Новый Структура("Ключ", Объект.ШаблонВвода);
	Иначе
		ПараметрыФормы = Новый Структура("ПоказательЗаполнения", Объект.НефинансовыйПоказатель);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ДокументИсточник", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.ШаблоныВводаНефинансовыхПоказателей.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СтруктураДляВызоваПроцедурМодуляМенеджера()
	
	ОбъектИПараметрыРасчета = Новый Структура;
	ОбъектИПараметрыРасчета.Вставить("Объект", Объект);
	ОбъектИПараметрыРасчета.Вставить("СтруктураОписанияВвода", ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров));
	ОбъектИПараметрыРасчета.Вставить("ТабличнаяЧасть", ТабличнаяЧасть);
	ОбъектИПараметрыРасчета.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
	Возврат ОбъектИПараметрыРасчета;
	
КонецФункции

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	Объект.ЗначенияКолонок.Очистить();
	Объект.СтрокиДокумента.Очистить();
	Объект.КолонкиДокумента.Очистить();
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону Тогда
		Объект.НефинансовыйПоказатель = Неопределено;
	Иначе
		Объект.ШаблонВвода = Неопределено;
	КонецЕсли;
	
	СохранитьТабличнуюЧастьВДокумент();
	УстановитьФормуДокумента();
	ВосстановитьТабличнуюЧастьДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииКолонкиСпискаНаСервере(ЭлементИмя)
	
	УстановитьЗначениеИзАналитики("Валюта_", Элементы.ТабличнаяЧасть.ТекущаяСтрока, ЭлементИмя);
	УстановитьЗначениеИзАналитики("ЕдИзм_", Элементы.ТабличнаяЧасть.ТекущаяСтрока, ЭлементИмя);
	
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьПриНачалеРедактированияНаСервере()
	
	УстановитьЗначениеИзАналитики("Валюта_", Элементы.ТабличнаяЧасть.ТекущаяСтрока, Неопределено);
	УстановитьЗначениеИзАналитики("ЕдИзм_", Элементы.ТабличнаяЧасть.ТекущаяСтрока, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СозданиеНовогоШаблона(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыФормы = Новый Структура("ЗначениеКопирования", Объект.ШаблонВвода);
	ПараметрыФормы.Вставить("ДокументИсточник", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.ШаблоныВводаНефинансовыхПоказателей.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборЗначенийКолонок(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		УстановитьЗначенияКолонокНаСервере(Результат, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияКолонокНаСервере(Результат, ДополнительныеПараметры)
	
	СтруктураПоискаЗначений = Новый Структура("Аналитика, ИмяИзмерения", ДополнительныеПараметры.Аналитика, "Аналитика");
	ЭлементыПоУмолчанию = Объект.ЗначенияКолонок.НайтиСтроки(СтруктураПоискаЗначений);
	Для Каждого Элемент из ЭлементыПоУмолчанию Цикл
		Объект.ЗначенияКолонок.Удалить(Элемент);
	КонецЦикла;
	СтруктураПоискаЗначений.Вставить("Значение");
	Для Каждого Элемент из Результат Цикл
		СтруктураПоискаЗначений.Значение = Элемент;
		Если Объект.ЗначенияКолонок.НайтиСтроки(СтруктураПоискаЗначений).Количество() Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Объект.ЗначенияКолонок.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПоискаЗначений);
	КонецЦикла;
	
	ПерерисоватьФорму();
	
	СтруктураПоиска = Новый Структура("АдресАналитикиВалюта", ДополнительныеПараметры.НомерАналитики);
	Если КэшСвойствПоказателей.НайтиСтроки(СтруктураПоиска).Количество() Тогда
		УстановитьЗначенияИзАналитикиПоСтрокам("Аналитика" + ДополнительныеПараметры.НомерАналитики, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборРежимаОчисткиСтрок(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	ЗаполнитьНаСервере(Результат = КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФормуДокумента()
	
	ПараметрыПериода = Новый Структура("НачалоПериода, ОкончаниеПериода", 
										Объект.НачалоПериода, Объект.ОкончаниеПериода);
	СтруктураОписанияВвода = Документы.УстановкаЗначенийНефинансовыхПоказателей.СтруктураОписанияПолейДокументаВвода(
																		Объект.ВидОперации, Объект.НефинансовыйПоказатель,
																		Объект.ШаблонВвода, Объект.ЗначенияКолонок.Выгрузить(),
																		ПараметрыПериода);
	
	АдресСтруктурыПараметров = ПоместитьВоВременноеХранилище(СтруктураОписанияВвода, УникальныйИдентификатор);
	
	ОтразитьСтруктуруШаблона(СтруктураОписанияВвода);
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	СтруктураОписанияВвода = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону Тогда
		Элементы.НефинансовыйПоказатель.Видимость = Ложь;
		Элементы.ШаблонВвода.Видимость = Истина;
	Иначе
		Элементы.ШаблонВвода.Видимость = Ложь;
		Элементы.НефинансовыйПоказатель.Видимость = Истина;
	КонецЕсли;
	
	Если СтруктураОписанияВвода <> Неопределено Тогда
		Если СтруктураОписанияВвода.Период = "Период" Тогда
			Элементы.НачалоПериода.Заголовок = НСтр("ru = 'Период с'");
			Элементы.НачалоПериода.Видимость = Истина;
			Элементы.СтраницыОкончаниеПериода.ТекущаяСтраница = Элементы.ОкончаниеПериодаЭлемент;
		ИначеЕсли СтруктураОписанияВвода.Период = "ДействуетС" Тогда
			Элементы.НачалоПериода.Заголовок = НСтр("ru = 'Действует с'");
			Элементы.НачалоПериода.Видимость = Истина;
			Элементы.СтраницыОкончаниеПериода.ТекущаяСтраница = Элементы.ДействуетПо;
		Иначе
			Элементы.НачалоПериода.Видимость = Ложь;
			Элементы.СтраницыОкончаниеПериода.ТекущаяСтраница = Элементы.ОкончаниеПериодаНет;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.Показатели.ПодчиненныеЭлементы.Количество()
		И Элементы.ТабличнаяЧасть.Видимость Тогда
		
		Элементы.Показатели.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.Показатели.ОтображатьЗаголовок = Истина;
	
		Элементы.ЗначенияПоказателей.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ЗначенияПоказателей.ОтображатьЗаголовок = Истина;
		
	Иначе
		
		Элементы.Показатели.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.Показатели.ОтображатьЗаголовок = Ложь;
	
		Элементы.ЗначенияПоказателей.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ЗначенияПоказателей.ОтображатьЗаголовок = Ложь;
		
	КонецЕсли;
	
	КнопкиНастройки = Элементы.НастроитьКолонки.ПодчиненныеЭлементы;
	Пока КнопкиНастройки.Количество() Цикл
		Элементы.Удалить(КнопкиНастройки[0]);
	КонецЦикла;
	
	Если СтруктураОписанияВвода <> Неопределено Тогда
		
		Элементы.Заполнить.Видимость = СтруктураОписанияВвода.Свойство("ПравилаЗаполнения");
		
		Если СтруктураОписанияВвода.Свойство("АналитикаКолонок") Тогда
			
			Для Каждого НайденнаяСтрока из СтруктураОписанияВвода.АналитикаКолонок Цикл
				НомерАналитики = СтруктураОписанияВвода.АналитикаКолонок.Индекс(НайденнаяСтрока) + 1;
				ИмяПоля = ФинансоваяОтчетностьПовтИсп.ИмяПоляБюджетногоОтчета(НайденнаяСтрока.Аналитика);
				НоваяКнопка = Элементы.Добавить(ИмяПоля, Тип("КнопкаФормы"), Элементы.НастроитьКолонки);
				НоваяКнопка.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
				НоваяКнопка.ИмяКоманды = "ВыбратьЗначенияКолонокАналитика" + НомерАналитики;
				НоваяКнопка.Заголовок = Строка(НайденнаяСтрока.Аналитика);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтразитьСтруктуруШаблона(СтруктураОписанияВвода)
	
	Для Каждого ДобавленныйЭлемент из ДобавленныеЭлементы Цикл
		Элемент = Элементы.Найти(ДобавленныйЭлемент.Значение);
		Если Элемент <> Неопределено Тогда
			Элементы.Удалить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	ЭлементыКУдалению = Новый Массив;
	Для Каждого Колонка из ЭтаФорма.ПолучитьРеквизиты("ТабличнаяЧасть") Цикл
		Если Колонка.Имя <> "НомерСтрокиДокумента" Тогда
			ЭлементыКУдалению.Добавить("ТабличнаяЧасть." + Колонка.Имя);
		КонецЕсли;
	КонецЦикла;
	
	ДобавленныеЭлементы.Очистить();
	
	Если СтруктураОписанияВвода = Неопределено Тогда
		
		ЭтаФорма.ИзменитьРеквизиты(,ЭлементыКУдалению);
		Возврат;
		
	КонецЕсли;
	
	Периодичность = СтруктураОписанияВвода.Периодичность;
	
	КэшСвойствПоказателей.Загрузить(СтруктураОписанияВвода.СвойстваПоказателей);
	
	Документы.УстановкаЗначенийНефинансовыхПоказателей.ОтразитьРеквизитыШапкиДокумента(СтруктураОписанияВвода, 
																						Элементы, ДобавленныеЭлементы);
	
	ЗначенияПоказателей.Очистить();
	Документы.УстановкаЗначенийНефинансовыхПоказателей.ОтразитьПоказателиРедактируемыеВШапке(СтруктураОписанияВвода, 
																				Элементы, ДобавленныеЭлементы, ЗначенияПоказателей);
	
	Документы.УстановкаЗначенийНефинансовыхПоказателей.ОтразитьТабличнуюЧастьДокумента(СтруктураОписанияВвода,
																				Элементы, ЭтаФорма, ДобавленныеЭлементы, ЭлементыКУдалению);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьТабличнуюЧастьДокумента()
	
	ТабличнаяЧасть.Очистить();
	
	СтруктураОписанияВвода = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
	
	Если СтруктураОписанияВвода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаПоказатель из ЗначенияПоказателей Цикл
		НайденныеСтроки = Объект.ЗначенияПоказателей.НайтиСтроки(Новый Структура("Показатель", СтрокаПоказатель.Показатель));
		Если НайденныеСтроки.Количество() Тогда
			ЗаполнитьЗначенияСвойств(СтрокаПоказатель, НайденныеСтроки[0]);
		КонецЕсли;
	КонецЦикла;
	
	КолонкиЗначенийТабличнойЧасти = СтруктураОписанияВвода.КолонкиЗначенийТабличнойЧасти;
	РедактируемыеКолонки = СтруктураОписанияВвода.РедактируемыеКолонки;
	ДеревоКолонокЗначений = СтруктураОписанияВвода.КолонкиЗначений;
	
	Для Каждого СтрокаДокумента из Объект.СтрокиДокумента Цикл
		
		НоваяСтрока = ТабличнаяЧасть.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумента);
		Для Каждого Колонка из КолонкиЗначенийТабличнойЧасти Цикл
			
			Если БюджетнаяОтчетностьКлиентСервер.ЛеваяЧастьИмениСовпадает(Колонка, "Валюта_")
				ИЛИ БюджетнаяОтчетностьКлиентСервер.ЛеваяЧастьИмениСовпадает(Колонка, "ЕдИзм_") Тогда
				Продолжить;
			КонецЕсли;
			
			ПоляКолонки = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(
				ДеревоКолонокЗначений.Строки.Найти(Колонка, "Имя", Истина).НакопленныйОтбор);
			ПоляКолонки.Вставить("НомерСтрокиДокумента", НоваяСтрока.НомерСтрокиДокумента);
			СтрокиЗначений = Объект.КолонкиДокумента.НайтиСтроки(ПоляКолонки);
			Если СтрокиЗначений.Количество() Тогда
				НоваяСтрока[Колонка] = СтрокиЗначений[0].Значение;
				Если КолонкиЗначенийТабличнойЧасти.Найти("Валюта_" + Колонка) <> Неопределено Тогда
					НоваяСтрока["Валюта_" + Колонка] = СтрокиЗначений[0].Валюта;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьТабличнуюЧастьВДокумент(Знач СтруктураОписанияВвода = Неопределено, ОбъектСохранения = Неопределено)
	
	Если СтруктураОписанияВвода = Неопределено Тогда
		СтруктураОписанияВвода = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
	КонецЕсли;
	
	Если ОбъектСохранения = Неопределено Тогда
		ТекущийОбъект = Объект;
	Иначе
		ТекущийОбъект = ОбъектСохранения;
	КонецЕсли;
	
	ОбъектИПараметрыРасчета = СтруктураДляВызоваПроцедурМодуляМенеджера();
	ОбъектИПараметрыРасчета.СтруктураОписанияВвода = СтруктураОписанияВвода;
	ОбъектИПараметрыРасчета.Объект = ТекущийОбъект;
	
	Документы.УстановкаЗначенийНефинансовыхПоказателей.СохранитьТабличнуюЧастьВДокумент(ОбъектИПараметрыРасчета, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеДокумента(СтруктураОписанияВвода, Отказ)
	Перем Ошибки;
	
	Для Каждого Элемент из СтруктураОписанияВвода.ЛеваяКолонка Цикл
		Если Не ЗначениеЗаполнено(Объект[Элемент.Имя]) Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнено поле """ + Элемент.Представление + """'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект." + Элемент.Имя, ТекстОшибки, "");
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Элемент из СтруктураОписанияВвода.ПраваяКолонка Цикл
		Если Не ЗначениеЗаполнено(Объект[Элемент.Имя]) Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнено поле """ + Элемент.Представление + """'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект." + Элемент.Имя, ТекстОшибки, "");
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти из ТабличнаяЧасть Цикл
		Для Каждого Структура ИЗ СтруктураОписанияВвода.РедактируемыеКолонки Цикл
			Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти[Структура.Имя]) Тогда
				Поле = "ТабличнаяЧасть[%1]." + Структура.Имя;
				Индекс = ТабличнаяЧасть.Индекс(СтрокаТабличнойЧасти);
				ТекстОшибки = НСтр("ru = 'В строке %1 не заполнено поле ""%2""'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, (Индекс + 1), Структура.Представление);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Поле, ТекстОшибки, "", Индекс);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если СтруктураОписанияВвода.Свойство("АналитикаКолонок") Тогда
		Для Каждого СтрокаАналитики ИЗ СтруктураОписанияВвода.АналитикаКолонок Цикл
			СтруктураПоиска = Новый Структура("ИмяИзмерения, Аналитика", "Аналитика", СтрокаАналитики.Аналитика);
			Если Не Объект.ЗначенияКолонок.НайтиСтроки(СтруктураПоиска).Количество() Тогда
				ТекстОшибки = НСтр("ru = 'Не указаны значения колонок """ + Строка(СтрокаАналитики.Аналитика) + """'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстОшибки, "");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНовыйШаблонНаСервере(Источник)
	
	Объект.ВидОперации = Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону;
	Объект.ШаблонВвода = Источник;
	
	ЗаполнитьЗначенияКолонокПоУмолчанию();
	
	ПерерисоватьФорму(Истина);
	
	Если Не ТабличнаяЧасть.Количество() Тогда
		ЗаполнитьЗначенияСтрокПоУмолчанию();
		УстановитьЗначенияИзАналитикиПоСтрокам(Неопределено, Истина, Истина);
	Иначе
		УстановитьЗначенияИзАналитикиПоСтрокам(Неопределено, Ложь, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанШаблонВводаНФП" Тогда
		Если Параметр = Объект.ШаблонВвода
			ИЛИ Источник = Объект.Ссылка Тогда
			УстановитьНовыйШаблонНаСервере(Параметр);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерерисоватьФорму(ПроверитьПериод = Ложь)
	
	СохранитьТабличнуюЧастьВДокумент();
	УстановитьФормуДокумента();
	ВосстановитьТабличнуюЧастьДокумента();
	
	Если ПроверитьПериод Тогда
		СтруктураОписанияВвода = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
		Если СтруктураОписанияВвода <> Неопределено
			И СтруктураОписанияВвода.Период <> "ДействуетС" Тогда
			Объект.НачалоПериода = БюджетированиеКлиентСервер.ДатаНачалаПериода(Объект.НачалоПериода, Периодичность);
			Объект.ОкончаниеПериода = БюджетированиеКлиентСервер.ДатаКонцаПериода(Объект.ОкончаниеПериода, Периодичность);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПериодЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.НачалоПериода = Результат.НачалоПериода;
	Объект.ОкончаниеПериода = Результат.КонецПериода;
	
	ПерерисоватьФорму(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере(УдалятьСтроки)
	
	ОбъектИПараметрыРасчета = СтруктураДляВызоваПроцедурМодуляМенеджера();
	Если ОбъектИПараметрыРасчета.СтруктураОписанияВвода <> Неопределено Тогда
		Документы.УстановкаЗначенийНефинансовыхПоказателей.ЗаполнитьНастроенныйДокумент(ОбъектИПараметрыРасчета, УдалятьСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СтрокаДублируетСуществующую(ТекущаяСтрока, НомерСтрокиДубля)
	
	СтрокаТаблицы = ТабличнаяЧасть.НайтиПоИдентификатору(ТекущаяСтрока);
	СтруктураОписанияВвода = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
	
	СтруктураПоиска = Новый Структура;
	Для Каждого Структура ИЗ СтруктураОписанияВвода.РедактируемыеКолонки Цикл
		СтруктураПоиска.Вставить(Структура.Имя, СтрокаТаблицы[Структура.Имя]);
	КонецЦикла;
	
	НайденныеСтроки = ТабличнаяЧасть.НайтиСтроки(СтруктураПоиска);
	Для Каждого НайденнаяСтрока из НайденныеСтроки Цикл
		Если НайденнаяСтрока <> СтрокаТаблицы Тогда
			НомерСтрокиДубля = НайденнаяСтрока.НомерСтрокиДокумента;
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокиПоУмолчаниюРекурсивно(РедактируемыеКолонки, ТаблицаЗначений, Уровень = 0, НакопленныйОтбор = Неопределено)
	
	Если Уровень = РедактируемыеКолонки.Количество() Тогда
		ЕстьЗначимые = Ложь;
		Если НакопленныйОтбор <> Неопределено Тогда
			Для Каждого КлючИЗначение из НакопленныйОтбор Цикл
				Если ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
					ЕстьЗначимые = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если Не ЕстьЗначимые Тогда
			Возврат;
		КонецЕсли;
		НоваяСтрока = ТабличнаяЧасть.Добавить();
		НоваяСтрока.НомерСтрокиДокумента = ТабличнаяЧасть.Индекс(НоваяСтрока) + 1;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, НакопленныйОтбор);
		Возврат;
	КонецЕсли;
	
	Если НакопленныйОтбор = Неопределено Тогда
		НакопленныйОтбор = Новый Структура;
	КонецЕсли;
	
	ТекущееИзмерение = РедактируемыеКолонки[Уровень].Имя;
	Аналитика = РедактируемыеКолонки[Уровень].Аналитика;
	
	Если СтрНайти(ТекущееИзмерение, "Аналитика") Тогда
		ИмяПоиска = "Аналитика";
	Иначе
		ИмяПоиска = ТекущееИзмерение;
	КонецЕсли;
	
	НайденныеЗначения = ТаблицаЗначений.НайтиСтроки(Новый Структура("ИмяИзмерения, Аналитика", ИмяПоиска, Аналитика));
	Если НайденныеЗначения.Количество() Тогда
		Для Каждого НайденнаяСтрока из НайденныеЗначения Цикл
			НакопленныйОтбор.Вставить(ТекущееИзмерение, НайденнаяСтрока.Значение);
			ДобавитьСтрокиПоУмолчаниюРекурсивно(РедактируемыеКолонки, ТаблицаЗначений, Уровень + 1, НакопленныйОтбор);
			НакопленныйОтбор.Удалить(ТекущееИзмерение);
		КонецЦикла;
	Иначе
		НакопленныйОтбор.Вставить(ТекущееИзмерение, Неопределено);
		ДобавитьСтрокиПоУмолчаниюРекурсивно(РедактируемыеКолонки, ТаблицаЗначений, Уровень + 1, НакопленныйОтбор);
		НакопленныйОтбор.Удалить(ТекущееИзмерение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияСтрокПоУмолчанию()
	
	Если Объект.ВидОперации <> Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОписанияВвода = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
	Если СтруктураОписанияВвода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЗначений = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ШаблонВвода, "ЗначенияСложнойТаблицыПоУмолчанию").Выгрузить();
	ДобавитьСтрокиПоУмолчаниюРекурсивно(СтруктураОписанияВвода.РедактируемыеКолонки, ТаблицаЗначений);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияКолонокПоУмолчанию()
	
	Объект.ЗначенияКолонок.Очистить();
	Если Объект.ВидОперации <> Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияКолонок = Документы.УстановкаЗначенийНефинансовыхПоказателей.ЗначенияКолонокШаблона(Объект.ШаблонВвода);
	Объект.ЗначенияКолонок.Загрузить(ЗначенияКолонок);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыСпискаРедактирования(ИндексСтрокиАналитики)
	
	СтруктураОписанияВвода = ПолучитьИзВременногоХранилища(АдресСтруктурыПараметров);
	Если СтруктураОписанияВвода = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Аналитика = СтруктураОписанияВвода.АналитикаКолонок[ИндексСтрокиАналитики - 1].Аналитика;
	
	СтруктураПоиска = Новый Структура("ИмяИзмерения, Аналитика", "Аналитика", Аналитика);
	ИскомыеЗначения = Объект.ЗначенияКолонок.Выгрузить(СтруктураПоиска);
	
	ПараметрыФормы = Новый Структура;
	ТипЗначения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Аналитика, "ТипЗначения");
	ПараметрыФормы.Вставить("ТипЗначения", ТипЗначения);
	ПараметрыФормы.Вставить("Заголовок", Строка(Аналитика));
	ПараметрыФормы.Вставить("Значения", ИскомыеЗначения.ВыгрузитьКолонку("Значение"));
	ПараметрыФормы.Вставить("Аналитика", Аналитика);
	
	ВидыАналитик = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КэшСвойствПоказателей[0].Показатель,
						"ВидАналитики1, ВидАналитики2, ВидАналитики3, ВидАналитики4, ВидАналитики5, ВидАналитики6");
	
	Если ВидыАналитик.ВидАналитики1 = Аналитика Тогда
		ПараметрыФормы.Вставить("НомерАналитики", 1);
	ИначеЕсли ВидыАналитик.ВидАналитики2 = Аналитика Тогда
		ПараметрыФормы.Вставить("НомерАналитики", 2);
	ИначеЕсли ВидыАналитик.ВидАналитики3 = Аналитика Тогда
		ПараметрыФормы.Вставить("НомерАналитики", 3);
	ИначеЕсли ВидыАналитик.ВидАналитики4 = Аналитика Тогда
		ПараметрыФормы.Вставить("НомерАналитики", 4);
	ИначеЕсли ВидыАналитик.ВидАналитики5 = Аналитика Тогда
		ПараметрыФормы.Вставить("НомерАналитики", 5);
	ИначеЕсли ВидыАналитик.ВидАналитики6 = Аналитика Тогда
		ПараметрыФормы.Вставить("НомерАналитики", 6);
	КонецЕсли;
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервереБезКонтекста
Функция ШаблонИспользуетсяВДокументах(ШаблонВвода, Документ)
	
	Возврат Справочники.ШаблоныВводаНефинансовыхПоказателей.ШаблонИспользуетсяВДокументах(ШаблонВвода, Документ);
	
КонецФункции

&НаСервере
Процедура УстановитьЗначениеИзАналитики(ТипЗначения, ИндексСтроки, ИсточникИзменения, КэшЗначенийАналитики = Неопределено)
	
	ОбъектИПараметрыРасчета = СтруктураДляВызоваПроцедурМодуляМенеджера();
	Документы.УстановкаЗначенийНефинансовыхПоказателей.УстановитьЗначениеИзАналитики(ОбъектИПараметрыРасчета, ТипЗначения, ИндексСтроки, ИсточникИзменения, КэшЗначенийАналитики);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияИзАналитикиПоСтрокам(ИсточникИзменения, Валюта, ЕдиницаИзмерения)
	
	КэшЗначенийАналитики = Новый Соответствие;
	Для Каждого СтрокаТабличнойЧасти из ТабличнаяЧасть Цикл
		Если Валюта Тогда
			УстановитьЗначениеИзАналитики("Валюта_", СтрокаТабличнойЧасти.ПолучитьИдентификатор(), ИсточникИзменения, КэшЗначенийАналитики);
		КонецЕсли;
		Если ЕдиницаИзмерения Тогда
			УстановитьЗначениеИзАналитики("ЕдИзм_", СтрокаТабличнойЧасти.ПолучитьИдентификатор(), ИсточникИзменения, КэшЗначенийАналитики);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НефинансовыйПоказательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Реквизиты = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(ВыбранноеЗначение, "ЗагружатьИзДругихПодсистем, ПоСценариям");
	ВводНедоступен = Реквизиты.ЗагружатьИзДругихПодсистем И Не Реквизиты.ПоСценариям;
	Если ВводНедоступен Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Значения для выбранного показателя всегда загружаются из других подсистем'"));
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти