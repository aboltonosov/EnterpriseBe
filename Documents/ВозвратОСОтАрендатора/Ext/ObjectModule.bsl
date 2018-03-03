﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ПередачаОСАрендатору") Тогда
		ЗаполнитьПоДокументуПередачаОСАрендатору(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	УправлениеВнеоборотнымиАктивамиПереопределяемый.ПроверитьОтсутствиеДублейВТабличнойЧасти(
		ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);
	
	Если НачислятьАмортизацию Тогда
		
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект, , НепроверяемыеРеквизиты, Отказ);
		
	Иначе
		
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходов");
		НепроверяемыеРеквизиты.Добавить("АналитикаРасходов");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Арендатор) И (Организация = Арендатор) Тогда
		Текст = НСтр("ru='Поля ""Организация"" и ""Арендатор"" должны различаться.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Арендатор",, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РассчитатьАмортизацию(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ОчиститьЗаписатьДвижения(Движения, "Хозрасчетный");
	
	ТаблицаРеквизитов = ТаблицаРеквизитовДокумента();
	
	УчетОСВызовСервера.ПроверитьСоответствиеОСОрганизации(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьСостояниеОСПринятоКУчету(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьСоответствиеМестонахожденияОС(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьЗаполнениеСчетаУчетаОС(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ВозвратОСОтАрендатора.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
	ДополнительныеСвойства.ТаблицыДляДвижений.Удалить("ПорядокОтраженияПрочихОпераций");
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	ДополнительныеСвойства.ТаблицыДляДвижений.Удалить("ОтражениеДокументовВРеглУчете");
	
	Для Каждого ТаблицаДвижений Из ДополнительныеСвойства.ТаблицыДляДвижений Цикл
		ПроведениеСерверУТ.ОтразитьДвижения(ТаблицаДвижений.Значение, Движения[ТаблицаДвижений.Ключ], Отказ);
	КонецЦикла;
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	СформироватьЗаданияКЗакрытиюМесяца();
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	Если Не Отказ Тогда
		РеглУчетПроведениеСервер.ОтразитьДокумент(Новый Структура("Ссылка, Дата, Организация", Ссылка, Дата));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	СформироватьЗаданияКЗакрытиюМесяца();
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	ПодразделениеПолучатель = Подразделение;
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуПередачаОСАрендатору(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеЗаполнения", ДанныеЗаполнения);
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ПередачаОСАрендатору.Организация КАК Организация,
	|	ПередачаОСАрендатору.ПодразделениеПолучатель КАК Подразделение,
	|	ПередачаОСАрендатору.Подразделение КАК ПодразделениеПолучатель,
	|	ПередачаОСАрендатору.РасчетыМеждуОрганизациямиАрендатор КАК РасчетыМеждуОрганизациямиАрендатор,
	|	ПередачаОСАрендатору.Арендатор КАК Арендатор,
	|	ПередачаОСАрендатору.Ссылка КАК ДокументОснование,
	|	ИСТИНА КАК ДокументНаОсновании,
	|	ПередачаОСАрендатору.ОС.(
	|		ОсновноеСредство КАК ОсновноеСредство
	|	)
	|ИЗ
	|	Документ.ПередачаОСАрендатору КАК ПередачаОСАрендатору
	|ГДЕ
	|	ПередачаОСАрендатору.Ссылка = &ДанныеЗаполнения";
	
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	ОС.Загрузить(Выборка.ОС.Выгрузить());
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&Ссылка КАК Регистратор,
		|	&Дата КАК Период,
		|	НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) КАК ДатаРасчета,
		|	&Номер,
		|	&Организация,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету) КАК СостояниеОС,
		|	""ОС"" КАК ИмяСписка,
		|	ИСТИНА КАК ВыдаватьСообщения,
		|	&Подразделение КАК Подразделение,
		|	НЕОПРЕДЕЛЕНО КАК МОЛ");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номер", Номер);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура РассчитатьАмортизацию(Отказ)
	
	НачисленнаяАмортизация.Очистить();
	
	ТаблицаНачисленнаяАмортизация = УчетОСВызовСервера.НачисленнаяАмортизация(
		ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство"), ТаблицаРеквизитовДокумента(), Отказ);
	
	ДополнительныеСвойства.Вставить("НачисленнаяАмортизация", ТаблицаНачисленнаяАмортизация);
	НачисленнаяАмортизация.Загрузить(ТаблицаНачисленнаяАмортизация);
	
КонецПроцедуры

Процедура СформироватьЗаданияКЗакрытиюМесяца()

	ДанныеТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	РасчетИмущественныхНалоговПереопределяемый.СформироватьЗаданиеКРасчетуНалогаНаИмущество(ДанныеТаблиц);
	РасчетИмущественныхНалоговПереопределяемый.СформироватьЗаданиеКРасчетуТранспортногоНалога(ДанныеТаблиц, Истина, Истина);
	РасчетИмущественныхНалоговПереопределяемый.СформироватьЗаданиеКРасчетуЗемельногоНалога(ДанныеТаблиц, Истина, Истина);
	УчетОСВызовСервера.СформироватьЗаданиеАмортизацияОС(ДанныеТаблиц);
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли
